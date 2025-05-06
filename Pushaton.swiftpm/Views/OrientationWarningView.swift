//
//  OrientationWarningView.swift
//
//
//  Created by Wit Owczarek on 22/01/2024.
//

import Foundation
import SwiftUI

struct OrientationWarningView: View {
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0.09 * UIScreen.main.bounds.size.height) {
                Image(systemName: "rectangle.portrait.rotate")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.red)
                    .frame(width: 110, height: 110)
                    .padding(15)
                    .background {
                        Color.red.opacity(0.2).cornerRadius(30)
                    }
                
                VStack(spacing: 0.05 * UIScreen.main.bounds.size.height) {
                    Text("Best In Landscape")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("Please rotate your device to landscape mode for the best app experience.")
                        .font(.body.weight(.medium))
                        .foregroundColor(Color.theme.secondaryText)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .frame(maxWidth: 420)
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .background(.background)
        .edgesIgnoringSafeArea(.all)
    }
}
