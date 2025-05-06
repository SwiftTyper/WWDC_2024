//
//  PrimaryButtonStyle.swift
//
//
//  Created by Wit Owczarek on 20/01/2024.
//

import Foundation
import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    
    let isDisabled: Bool
    
    public init(isDisabled: Bool) { self.isDisabled = isDisabled }
    
    public func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(Color.theme.primaryAccent)
            .foregroundColor(.white)
            .cornerRadius(8)
            .font(.body.weight(.semibold))
            .opacity(isDisabled ? 0.5 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
    
}
