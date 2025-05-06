//
//  File.swift
//  
//
//  Created by Wit Owczarek on 16/12/2023.
//

/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import AVFoundation
import Foundation

extension AVCaptureVideoDataOutput {
    
    static func withPixelFormatType(_ pixelFormatType: OSType) -> AVCaptureVideoDataOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        let validPixelTypes = videoDataOutput.availableVideoPixelFormatTypes

        guard validPixelTypes.contains(pixelFormatType) else { fatalError("Failed configuration") }

        let pixelTypeKey = String(kCVPixelBufferPixelFormatTypeKey)
        videoDataOutput.videoSettings = [pixelTypeKey: pixelFormatType]

        return videoDataOutput
    }
}
