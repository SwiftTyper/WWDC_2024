//
//  PushupClassifier+Singleton.swift
//
//
//  Created by Wit Owczarek on 15/12/2023.
//

import CoreML

extension PushupClassifierV3 {
    
    static let shared: PushupClassifierV3 = {
        let defaultConfig = MLModelConfiguration()
        
        guard let pushupClassifer = try? PushupClassifierV3(configuration: defaultConfig) else {
            fatalError("Pushup Classifier failed to initialize.")
        }
        
        return pushupClassifer
    }()
}

