//
//  ContentView.swift
//  
//
//  Created by Wit Owczarek on 29/12/2023.
//

import Foundation
import SwiftUI
import SpriteKit


struct ContentView: View {
    
    @StateObject var viewModel: PredictionViewModel = .init()
    
    @State private var isPortrait: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading){
//            #if DEBUG
//                GameView()
//            #else
            if !isPortrait {
                if viewModel.isShowingGame && !viewModel.showOnboarding || viewModel.isGameOver{
                    GameView()
                }
                CameraOverlay()
            } else {
                OrientationWarningView()
            }
//            #endif
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.showOnboarding) {
            OnboardingView(viewModel: .init(didSelectGetStarted: viewModel.dismissOnboarding))
                .interactiveDismissDisabled()
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                self.isPortrait = isInPortrait()
                self.viewModel.videoCapture.updateDeviceOrientation()
            }
            self.viewModel.videoCapture.updateDeviceOrientation()
            self.isPortrait = isInPortrait()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
        }
    }
    
}


extension ContentView {
    
    static let hasSeenOnboardingKey = "hasSeenOnboarding"
    

    func isInPortrait() -> Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
}


