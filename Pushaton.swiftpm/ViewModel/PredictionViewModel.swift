//
//  PredictionViewModel.swift
//
//
//  Created by Wit Owczarek on 16/12/2023.
//

import Foundation
import SwiftUI
import CreateMLComponents
import Combine

class PredictionViewModel: ObservableObject {
    
    @Published var currentFrame: (CGImage, [Pose])?
    @Published var confidence: String = "Observing..."
    @Published var predicted: String = ""
    
    @Published var isGameOver: Bool = false
    
    @Published var isPersonFullyDetected: Bool = false
    @Published var showOnboarding: Bool = true
    @Published private var isWithinPersonDetectedGracePeriod: Bool = false
    
    @Published var isShowingGame: Bool = false
    @Published var countdownTime: Int = 0
    
    private var personDetectedGracePeriod: Timer?
    private var pushupPositionGracePeriod: Timer?
    
    var countdownTimer: AnyCancellable?
    
    private let startPeriodDuration: TimeInterval = 3
    private let gracePeriodDuration: TimeInterval = 3
    
    private var cancellables = Set<AnyCancellable>()
    
    var videoCapture: VideoCapture!	
    var videoProcessingChain: VideoProcessingChain!
    
    init() {
        videoProcessingChain = VideoProcessingChain()
        videoProcessingChain.delegate = self
        
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        
        self.showOnboarding = shouldShowOnboarding()
        setupConditionMonitoring()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func updateLabels(with prediction: ActionPrediction) {
        if prediction.label != self.predicted {
            DispatchQueue.main.async {
                self.predicted = prediction.label
                self.confidence = prediction.confidenceString ?? "Observing..."
            }
        }
    }
    
    func setDisplayImage(image: CGImage, poses: [Pose]?) {
        DispatchQueue.main.async{
            self.currentFrame = (image, poses ?? [])
        }
    }
    
    
    func checkIfPersonFullyDetected(poses: [Pose]?){
        guard let main = poses?.max(by:) ({ pose1, pose2 in pose1.area < pose2.area }) else { return }
        let newState = main.hasNecessaryKeypoints()
        let previousState = isPersonFullyDetected
        
        DispatchQueue.main.async {
            self.isPersonFullyDetected = newState
            
            if newState && !previousState {
                self.resetPersonDetectedGracePeriod()
            } else if !newState && previousState {
                self.startPersonDetectedGracePeriod()
            }
        }
    }
    
    func setupConditionMonitoring() {
        Publishers.CombineLatest($isPersonFullyDetected, $isWithinPersonDetectedGracePeriod)
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] (isPersonFullyDetected, isWithinPersonDetectedGracePeriod) in
                guard let self = self else { return }
                guard !self.showOnboarding else { return }
                if isPersonFullyDetected && !self.isShowingGame {
                    self.startConditionMetTimer()
                } else if !isWithinPersonDetectedGracePeriod && self.isShowingGame && !isPersonFullyDetected {
                    withAnimation {
                        self.isShowingGame = false
                    }
                    self.resetConditionMetTimer()
                } else {
                    self.resetConditionMetTimer()
                }
            }
            .store(in: &cancellables)
    }
    
    func stopConditionMonitoring() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    private func startConditionMetTimer() {
        resetConditionMetTimer()
        
        countdownTime = Int(startPeriodDuration)
              
        countdownTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.countdownTime > 1 {
                    self.countdownTime -= 1
                } else {
                    withAnimation {
                        self.isShowingGame = true
                    }
                    self.resetConditionMetTimer()
                }
            }
    }
    
    func getConditionCountdownColor() -> Color {
        let colors = [Color.red, Color(UIColor.yellow), Color.green]
        let index = 3 - countdownTime
        return colors[index]
    }

    private func resetConditionMetTimer() {
        countdownTimer?.cancel()
        countdownTimer = nil
        AudioPlayerManager.shared.stopAudio()
        countdownTime = 3
    }
    
    private func startPersonDetectedGracePeriod() {
        isWithinPersonDetectedGracePeriod = true
        personDetectedGracePeriod?.invalidate()
        personDetectedGracePeriod = Timer.scheduledTimer(withTimeInterval: gracePeriodDuration, repeats: false) { [weak self] _ in
            self?.isWithinPersonDetectedGracePeriod = false
        }
    }
        
    private func resetPersonDetectedGracePeriod() {
        isWithinPersonDetectedGracePeriod = false
        personDetectedGracePeriod?.invalidate()
        personDetectedGracePeriod = nil
        
    }
}

extension PredictionViewModel: VideoCaptureDelegate {
    
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher) {
        updateLabels(with: .startingPrediction)
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
 
}

extension PredictionViewModel: VideoProcessingChainDelegate {
    
    func videoProcessingChain(_ chain: VideoProcessingChain, didPredict actionPrediction: ActionPrediction, for frames: Int) {
        DispatchQueue.main.async {
            self.updateLabels(with: actionPrediction)
        }
    }
    
    func videoProcessingChain(_ chain: VideoProcessingChain,didDetect poses: [Pose]?,in frame: CGImage) {
        checkIfPersonFullyDetected(poses: poses)
        setDisplayImage(image: frame, poses: poses)
    }
}


extension PredictionViewModel {
    func shouldShowOnboarding() -> Bool {
        return !UserDefaults.standard.bool(forKey: ContentView.hasSeenOnboardingKey)
    }
    
    func dismissOnboarding() {
        withAnimation {
            self.showOnboarding = false
        }
        UserDefaults.standard.set(true, forKey: ContentView.hasSeenOnboardingKey)
    }
    
}
