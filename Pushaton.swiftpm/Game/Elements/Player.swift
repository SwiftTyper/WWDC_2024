//
//  Player.swift
//  
//
//  Created by Wit Owczarek on 02/01/2024.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    var isMoveDown = false
    
    init() {
        let texture = SKTexture(imageNamed: "idle 1")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Player"
        zPosition = 3.0
        anchorPoint = CGPoint(x: 0.5, y: 0.2)
        
        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody!.affectedByGravity = true
        physicsBody!.allowsRotation = false
        physicsBody!.isDynamic = true
        physicsBody!.pinned = false
        
        physicsBody!.categoryBitMask = GameScene.Collision.Masks.player.bitmask
        physicsBody!.collisionBitMask = GameScene.Collision.Masks.ground.bitmask
        physicsBody!.contactTestBitMask = GameScene.Collision.Masks.killing.bitmask | GameScene.Collision.Masks.reward.bitmask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configurations

extension Player {
    
    func setupPlayer(_ ground: Ground, scene: SKScene) {
        position = CGPoint(x: scene.frame.width/2.0 - (scene.size.width/10), y: scene.size.height/2)
        scene.addChild(self)
    }
}
