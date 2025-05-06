/*
Copyright © 2021 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

//
//  ActionPrediction.swift
//  
//
//  Modified by Wit Owczarek on 15/12/2023.
//

import Foundation

struct ActionPrediction {
    let label: String
    let confidence: Double!

    var confidenceString: String? {
        guard let confidence = confidence else {
            return nil
        }
        let percent = confidence * 100
        let formatString = percent >= 99.5 ? "%2.0f %%" : "%2.1f %%"
        return String(format: formatString, percent)
    }

    init(label: String, confidence: Double) {
        self.label = label
        self.confidence = confidence
    }
}

extension ActionPrediction {
    private enum AppLabel: String {
        case starting = "Starting Up"
        case noPerson = "No Person"
        case lowConfidence = "Low Confidence"
    }

    static let startingPrediction = ActionPrediction(.starting)
    static let noPersonPrediction = ActionPrediction(.noPerson)
    static let lowConfidencePrediction = ActionPrediction(.lowConfidence)

    private init(_ otherLabel: AppLabel) {
        label = otherLabel.rawValue
        confidence = nil
    }
}
