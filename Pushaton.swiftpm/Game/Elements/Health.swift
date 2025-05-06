//
//  Health.swift
//
//
//  Created by Wit Owczarek on 06/01/2024.
//

import Foundation
import SpriteKit

class Health: SKSpriteNode {
    
    var hearts: [SKSpriteNode] = []
    
    @Published var isHit: Bool = false
    
    init() {
        let texture = SKTexture(imageNamed: "heart")
        super.init(texture: texture, color: .clear, size: texture.size())
        size = CGSize(width: 40, height: 40)
        name = "heart"
        zPosition = 3
        anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillHearts(scene: GameScene) {
        let spacing: CGFloat = 8
        for index in -1...1 {
            let heart = Health()
            let xPosition = scene.size.width/2 + (heart.size.width + spacing) * CGFloat(index)
            let position = CGPoint(x: xPosition, y: scene.size.height-30)
            
            let emptyHeart = SKSpriteNode(texture: SKTexture(imageNamed: "dark heart"))
            emptyHeart.size = CGSize(width: 40, height: 40)
            emptyHeart.anchorPoint = CGPoint(x: 0.5, y: 1)
            emptyHeart.zPosition = 2
            emptyHeart.position = position
            scene.addChild(emptyHeart)
            
            heart.position = position
            hearts.append(heart)
            
            
            scene.addChild(heart)
        }
    }
    
    func loseHeart(scene: GameScene) {
        if isHit == false {
            isHit = true
            
            scene.run(Sound.boxcollision.action)
    
            if let lastHeart = hearts.popLast(),!hearts.isEmpty {
                lastHeart.removeFromParent()
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    self.isHit = false
                }
                
            } else {
                scene.setupGameOver()
            }
            
            invincible(scene: scene)
       }
    }
    
    func invincible(scene: GameScene) {
        scene.playerStateController.enter(StunnedState.self)
    }
    
}
