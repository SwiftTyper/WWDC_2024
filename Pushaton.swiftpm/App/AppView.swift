//
//  AppView.swift
//
//
//  Created by Wit Owczarek on 14/12/2023.
//

import Foundation
import SwiftUI

@main
struct AppView: App {
   
    init() {
        CustomFonts.register()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
  
}

