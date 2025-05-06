/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//
//  VideoProcessingChain.swift
//
//
//  Modified by Wit Owczarek on 16/12/2023.
//

import Foundation
import Vision
import Combine
import CoreImage
import CreateMLComponents

protocol VideoProcessingChainDelegate: AnyObject {
    func videoProcessingChain(_ chain: VideoProcessingChain, didDetect poses: [Pose]?, in frame: CGImage)
    func videoProcessingChain(_ chain: VideoProcessingChain, didPredict actionPrediction: ActionPrediction, for frames: Int)
}

struct VideoProcessingChain {
    
    weak var delegate: VideoProcessingChainDelegate?

    var upstreamFramePublisher: AnyPublisher<Frame, Never>! {
        didSet { buildProcessingChain() }
    }
    
    private var frameProcessingChain: AnyCancellable?
    private let humanBodyPoseRequest = VNDetectHumanBodyPoseRequest()
    private let actionClassifier = PushupClassifierV3.shared
    private let predictionWindowSize: Int
    private let windowStride = 15

    init() {
        predictionWindowSize = actionClassifier.calculatePredictionWindowSize()
    }
}

extension VideoProcessingChain {
    
    private mutating func buildProcessingChain() {
        guard upstreamFramePublisher != nil else { return }
        
        frameProcessingChain = upstreamFramePublisher
            .compactMap(imageFromFrame)
            .map(findPosesInFrame)
            .flatMap { [self] poses -> AnyPublisher<Pose, Never> in
                guard let largestPose = self.isolateLargestPose(poses) else {
                   return Empty<Pose, Never>().eraseToAnyPublisher()
               }
               return Just(largestPose).eraseToAnyPublisher()
            }
            .map(multiArrayFromPose)
            .scan([MLMultiArray](), gatherWindow)
            .filter(gateWindow)
            .map(predictActionWithWindow)
            .sink(receiveValue: sendPrediction)
        
    }
}

extension VideoProcessingChain {
    
    private func imageFromFrame(_ buffer: Frame) -> CGImage? {
        guard let imageBuffer = buffer.imageBuffer else {
            print("The frame doesn't have an underlying image buffer.")
            return nil
        }

        let ciContext = CIContext(options: nil)
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            print("Unable to create an image from a frame.")
            return nil
        }
        
        return cgImage
    }

    private func findPosesInFrame(_ frame: CGImage) -> [Pose]? {
        let visionRequestHandler = VNImageRequestHandler(cgImage: frame)
        
        do { try visionRequestHandler.perform([humanBodyPoseRequest]) } catch {
            assertionFailure("Human Pose Request failed: \(error)")
        }

        let poses = Pose.fromObservations(humanBodyPoseRequest.results)
        
        DispatchQueue.main.async {
            self.delegate?.videoProcessingChain(self, didDetect: poses, in: frame)
        }

        return poses
    }

    private func isolateLargestPose(_ poses: [Pose]?) -> Pose? {
        return poses?.max(by:) { pose1, pose2 in pose1.area < pose2.area }
    }

    private func multiArrayFromPose(_ item: Pose) -> MLMultiArray {
        return item.multiArray
    }

    private func gatherWindow(previousWindow: [MLMultiArray], multiArray: MLMultiArray) -> [MLMultiArray] {
        var currentWindow = previousWindow
        
        if previousWindow.count == predictionWindowSize {
            currentWindow.removeFirst(windowStride)
        }
        
        currentWindow.append(multiArray)
        return currentWindow
    }

    private func gateWindow(_ currentWindow: [MLMultiArray]) -> Bool {
        return currentWindow.count == predictionWindowSize
    }

    private func predictActionWithWindow(_ currentWindow: [MLMultiArray]) -> ActionPrediction {
        let mergedWindow = MLMultiArray(concatenating: currentWindow, axis: 1, dataType: .float)
        let prediction = actionClassifier.predictActionFromWindow(mergedWindow)
        return checkConfidence(prediction)
    }

    private func checkConfidence(_ actionPrediction: ActionPrediction) -> ActionPrediction {
        let minimumConfidence = 0.40
        let lowConfidence = actionPrediction.confidence < minimumConfidence
        return lowConfidence ? .lowConfidencePrediction : actionPrediction
    }

    private func sendPrediction(_ actionPrediction: ActionPrediction) {
        DispatchQueue.main.async {
            self.delegate?.videoProcessingChain(self, didPredict: actionPrediction, for: windowStride)
        }
    }
}
