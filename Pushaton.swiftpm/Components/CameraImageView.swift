//
//  CameraImageView.swift
//
//
//  Created by Wit Owczarek on 15/12/2023.
//

import Foundation
import SwiftUI

struct CameraImageView: View {
    
    let cameraImage: CGImage
    
    var body: some View {
        Image(cameraImage, scale: 1.0, label: Text("Camera"))
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
}
