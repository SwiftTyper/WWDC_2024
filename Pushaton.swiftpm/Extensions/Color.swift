//
//  Color.swift
//  
//
//  Created by Wit Owczarek on 20/01/2024.

import Foundation
import SwiftUI

extension Color {
    
    struct Theme {
        
        var primaryText: Color {
            Color("textPrimary")
        }
        
        var secondaryText: Color {
            Color("textSecondary")
        }
        
        var primaryAccent: Color {
            Color("primaryAccent")
        }
        
        var secondaryAccent: Color {
            Color("secondaryAccent")
        }
        
    }
}

extension Color {
    static let theme = Color.Theme()
}

