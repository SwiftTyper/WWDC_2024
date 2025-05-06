
/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//
//  VideoCapture.swift
//
//
//  Modified by Wit Owczarek on 16/12/2023.
//

import UIKit
import Combine
import AVFoundation
import Foundation

typealias Frame = CMSampleBuffer
typealias FramePublisher = AnyPublisher<Frame, Never>

protocol VideoCaptureDelegate: AnyObject {
    func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher)
}

class VideoCapture: NSObject {
    
    weak var delegate: VideoCaptureDelegate! {
        didSet { createVideoFramePublisher() }
    }
    
    var isEnabled = true {
        didSet { isEnabled ? enableCaptureSession() : disableCaptureSession() }
    }

    private var cameraPosition = AVCaptureDevice.Position.front {
        didSet { createVideoFramePublisher() }
    }

    private var orientation = AVCaptureVideoOrientation.landscapeRight {
        didSet { createVideoFramePublisher() }
    }

    private let captureSession = AVCaptureSession()
    private var framePublisher: PassthroughSubject<Frame, Never>?
    private let videoCaptureQueue = DispatchQueue(label: "Video Capture Queue", qos: .userInitiated)

    private var horizontalFlip: Bool {
        cameraPosition == .front
    }

    func toggleCameraSelection() {
        cameraPosition = cameraPosition == .back ? .front : .back
    }

    func updateDeviceOrientation() {
        let currentPhysicalOrientation = UIDevice.current.orientation

        switch currentPhysicalOrientation {
            case .landscapeLeft:
                orientation = .landscapeRight
            case .landscapeRight:
                orientation = .landscapeLeft
            default:
                orientation = .landscapeRight
        }
    }

    private func enableCaptureSession() {
        if !captureSession.isRunning { captureSession.startRunning() }
    }

    private func disableCaptureSession() {
        if captureSession.isRunning { captureSession.stopRunning() }
    }
}

// MARK: - AV Capture Video Data Output Sample Buffer Delegate
extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput frame: Frame, from connection: AVCaptureConnection) {
        framePublisher?.send(frame)
    }
}

// MARK: - Capture Session Configuration
extension VideoCapture {
    
    private func createVideoFramePublisher() {
        guard let videoDataOutput = configureCaptureSession() else { return }
        let passthroughSubject = PassthroughSubject<Frame, Never>()
        framePublisher = passthroughSubject
        videoDataOutput.setSampleBufferDelegate(self, queue: videoCaptureQueue)
        let genericFramePublisher = passthroughSubject.eraseToAnyPublisher()
        delegate.videoCapture(self, didCreate: genericFramePublisher)
    }

    private func configureCaptureSession() -> AVCaptureVideoDataOutput? {
        disableCaptureSession()

        guard isEnabled else { return nil }

        defer { enableCaptureSession() }
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        let modelFrameRate = PushupClassifierV3.frameRate
        let input = AVCaptureDeviceInput.createCameraInput(position: cameraPosition, frameRate: modelFrameRate)
        let output = AVCaptureVideoDataOutput.withPixelFormatType(kCVPixelFormatType_32BGRA)

        let success = configureCaptureConnection(input, output)
        return success ? output : nil
    }

    private func configureCaptureConnection(_ input: AVCaptureDeviceInput?, _ output: AVCaptureVideoDataOutput?) -> Bool {
        guard let input = input else { return false }
        guard let output = output else { return false }

        captureSession.inputs.forEach(captureSession.removeInput)
        captureSession.outputs.forEach(captureSession.removeOutput)

        guard captureSession.canAddInput(input) else { return false }
        guard captureSession.canAddOutput(output) else { return false }

        captureSession.addInput(input)
        captureSession.addOutput(output)

        guard captureSession.connections.count == 1 else {
            let count = captureSession.connections.count
            print("The capture session has \(count) connections instead of 1.")
            return false
        }

        guard let connection = captureSession.connections.first else {
            print("Getting the first/only capture-session connection shouldn't fail.")
            return false
        }

        if connection.isVideoOrientationSupported {
            connection.videoOrientation = orientation
        }

        if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = horizontalFlip
        }

        output.alwaysDiscardsLateVideoFrames = true

        return true
    }
}
