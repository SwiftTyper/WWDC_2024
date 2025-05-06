//
//  Obstacle.swift
//  
//
//  Created by Wit Owczarek on 06/01/2024.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode {
    var timer: Timer?
    var obstacles: Set<SKSpriteNode> = []
    
    init() {
        let texture = SKTexture(imageNamed: "rock light")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Obstacle"
        zPosition = 1
        anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Obstacle {
    
    @objc func setupObstacles(scene: GameScene){
        let sprite = Obstacle()
        let y = scene.size.height/2 + scene.size.width * 9/16 * 0.07 - (scene.size.width * 9/32) + 100
        sprite.position = CGPoint(x: scene.size.width * 1.5, y: y)
        
        sprite.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.isDynamic = true
        sprite.physicsBody!.categoryBitMask = GameScene.Collision.Masks.killing.bitmask
        sprite.physicsBody!.collisionBitMask = GameScene.Collision.Masks.ground.bitmask
        sprite.physicsBody!.contactTestBitMask = GameScene.Collision.Masks.player.bitmask
        
        if !scene.isPaused {
            scene.addChild(sprite)
        }
        
        scene.coin.spawnCoins(scene: scene, obstacle: sprite)
        
        startObstacleSpawnTimer(scene: scene)
    }
    
    func moveObstacles(scene: GameScene) {
        scene.enumerateChildNodes(withName: "Obstacle") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= scene.velocityX
            
            if node.position.x < scene.size.width + self.size.width {
                node.physicsBody?.affectedByGravity = true
            }
            
            if node.position.x < -self.size.width{
                node.removeFromParent()
            }
        }
    }
    
    func startObstacleSpawnTimer(scene: GameScene) {
        timer?.invalidate()
        
        let random = CGFloat.random(in: 3.5...8.5)
        
        timer = Timer.scheduledTimer(withTimeInterval: random, repeats: true, block: { timer in
            self.setupObstacles(scene: scene)
        })
    }
    
}


