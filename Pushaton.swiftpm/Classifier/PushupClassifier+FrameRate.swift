//
//  PushupClassifier+FrameRate.swift
//
//
//  Created by Wit Owczarek on 17/12/2023.
//

import Foundation
import CoreML

extension PushupClassifierV3 {
    
    static let frameRate:Double = 30.0
    
    func calculatePredictionWindowSize() -> Int {
        let modelDescription = model.modelDescription
        guard let dimmensions = model.modelDescription.inputDescriptionsByName.first?.value.multiArrayConstraint?.shape else {
            fatalError("Falied To retrive the models multiarray dimmensions")
        }
        return Int(truncating: dimmensions[1])
    }
}
