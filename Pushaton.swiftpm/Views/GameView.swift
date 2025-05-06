//
//  GameView.swift
//  
//
//  Created by Wit Owczarek on 22/01/2024.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @EnvironmentObject var viewModel: PredictionViewModel
    
    var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size, viewModel: viewModel)
        scene.scaleMode = .aspectFill
        scene.view?.showsPhysics = true
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
            .ignoresSafeArea(.all)
            .statusBarHidden()
    }
}

