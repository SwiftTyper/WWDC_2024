//
//  Coin.swift
//
//
//  Created by Wit Owczarek on 06/01/2024.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode {
    
    var timer: Timer?
    
    init() {
        let texture = SKTexture(imageNamed: "coin light 1")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "coin"
        zPosition = 1
        setScale(0.5)
        anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let textures: Array<SKTexture> = (1...9).map { "coin light \($0)"}.map(SKTexture.init)
        run(.repeatForever(.animate(with: textures, timePerFrame: 0.1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Coin {
    
    func spawnCoins(scene: GameScene, obstacle: SKSpriteNode?){
        
        guard Int.random(in: 0..<3) == 0 else { return }
        guard let obstacle = obstacle else { return }
        
        let type = Arrangement.getRandom()
        let y = scene.size.height/2 + scene.size.width * 9/16 * 0.07 - (scene.size.width * 9/32) + 100
        
        if type == .straight {
            let length = Bool.random() ? 6 : 4
            for i in 1...length {
                let sprite = Coin()
                sprite.position = CGPoint(x: (obstacle.position.x) - (size.width * CGFloat(i) * 2) - obstacle.size.width/2, y: y + obstacle.size.height)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
                sprite.physicsBody?.isDynamic = true
                sprite.physicsBody?.affectedByGravity = false
            
                sprite.physicsBody!.categoryBitMask = GameScene.Collision.Masks.reward.bitmask
                sprite.physicsBody!.contactTestBitMask = GameScene.Collision.Masks.player.bitmask
                scene.addChild(sprite)
            }
        } else if type == .doubleStraight{
            for j in 0..<2 {
                for i in 1...6 {
                    let sprite = Coin()
                    sprite.position = CGPoint(x: (obstacle.position.x) - (size.width * CGFloat(i) * 2)  - obstacle.size.width/2, y: y + obstacle.size.height + (size.height * CGFloat(j) * 2))
                    sprite.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
                    sprite.physicsBody?.isDynamic = true
                    sprite.physicsBody?.affectedByGravity = false
                
                    sprite.physicsBody!.categoryBitMask = GameScene.Collision.Masks.reward.bitmask
                    sprite.physicsBody!.contactTestBitMask = GameScene.Collision.Masks.player.bitmask
                    scene.addChild(sprite)
                }
            }
        } else {
            let radius: CGFloat = 100
            for i in 0..<5 {
                let angle = CGFloat(i) * (CGFloat.pi / 4)
                let x = obstacle.position.x + radius  * cos(angle)
                let y = y + obstacle.size.height + radius * sin(angle)
                
                let sprite = Coin()
                sprite.position = CGPoint(x: x, y: y)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2)
                sprite.physicsBody?.isDynamic = true
                sprite.physicsBody?.affectedByGravity = false
                
                sprite.physicsBody!.categoryBitMask = GameScene.Collision.Masks.reward.bitmask
                sprite.physicsBody!.contactTestBitMask = GameScene.Collision.Masks.player.bitmask
                
                scene.addChild(sprite)
                
            }
        }
        
    }
    
    func moveCoins(scene: GameScene) {
        scene.enumerateChildNodes(withName: "coin") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.x -= scene.velocityX
            
            if node.position.x < -self.size.width {
                node.removeFromParent()
            }
        }
    }
    
}

extension Coin {
    enum Arrangement {
        case straight
        case doubleStraight
        case arc
        
        static func getRandom() -> Arrangement{
            let randomNumber = Int.random(in: 1...7)
           
            switch randomNumber {
            case 1...4:
               return Arrangement.straight
            case 5, 6:
               return Arrangement.arc
            default:
               return Arrangement.doubleStraight
           }
        }
    }
}
