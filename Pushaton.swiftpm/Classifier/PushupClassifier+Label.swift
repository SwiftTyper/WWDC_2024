//
//  PushupClassifier+Label.swift
//
//
//  Created by Wit Owczarek on 15/12/2023.
//

import Foundation

extension PushupClassifierV3 {
    
    enum Label: String, CaseIterable {
        case pushupUp = "Pushup Up"
        case pushupUpHold = "Pushup Up Hold"
        case pushupDownHold = "Pushup Down Hold"
        case pushupDown = "Pushup Down"
        
        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
            }

            self = label
        }
    }
}
