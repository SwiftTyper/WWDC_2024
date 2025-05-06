//
//  PushupClassifier+PredictionAction.swift
//
//
//  Created by Wit Owczarek on 15/12/2023.
//

import CoreML

extension PushupClassifierV3 {
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let action = Label(output.label)
            let confidence = output.labelProbabilities[output.label]!
            return ActionPrediction(label: action.rawValue, confidence: confidence)
            
        } catch {
            fatalError("Pushup Classifier prediction error: \(error)")
        }
    }
}
