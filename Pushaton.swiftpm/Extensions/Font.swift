//
//  Font.swift
//
//
//  Created by Wit Owczarek on 07/01/2024.
//

import Foundation
import SwiftUI

enum MyCustomFonts: String, CaseIterable {
    case main = "PixeloidSans-Bold.ttf"
    var fontName: String { String(self.rawValue.dropLast(4)) }
    var fileExtension: String { String(self.rawValue.suffix(3)) }
}


struct CustomFonts {
    static func register() {
        MyCustomFonts.allCases.forEach {
            registerFont(fontName: $0.fontName, fontExtension: $0.fileExtension)
        }
    }
    
    private static func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Couldn't create \(fontName) from data")
            return
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
