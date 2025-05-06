//
//  Ground.swift
//  
//
//  Created by Wit Owczarek on 02/01/2024.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "terrain")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "terrain"
        zPosition = 0
        anchorPoint = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configurations

extension Ground {
    
    func setupGround(_ scene: SKScene) {
        
        for i in 0...3 {
            let ground = Ground()
            ground.size = CGSize(width: 532, height: 106)
            ground.anchorPoint = .zero
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.size.width, y: scene.size.height/2 + scene.size.width * 9/16 * 0.07 - (scene.size.width * 9/32 + ground.frame.size.height) + 100)
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.allowsRotation = false
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.pinned = false
            
            ground.physicsBody?.categoryBitMask = GameScene.Collision.Masks.ground.bitmask
            ground.physicsBody?.collisionBitMask = GameScene.Collision.Masks.player.bitmask | GameScene.Collision.Masks.killing.bitmask
            ground.physicsBody?.contactTestBitMask = GameScene.Collision.Masks.player.bitmask | GameScene.Collision.Masks.killing.bitmask
            
            scene.addChild(ground)
        }
    }
    
    func moveGround(_ scene: SKScene, speed: CGFloat) {
        scene.enumerateChildNodes(withName: "terrain") { (node, index) in
            let node = node as! SKSpriteNode
            node.position.x -= speed
            
            if node.position.x < -532 {
                node.position.x += (4 * 532)
            }
        }
    }
}
