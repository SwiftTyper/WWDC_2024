//
//  Background.swift
//
//
//  Created by Wit Owczarek on 02/01/2024.
//

import Foundation
import SpriteKit

class Background  {
    
    func setupBackground(_ scene: SKScene) {
        let textureWidth = Int(scene.size.width)
        let textureHeight = Int(scene.size.width * 9/16)
        
        for swapIndex in 0..<2 {
            for i in 1...5 {
                let bg = SKSpriteNode(imageNamed: "background_\(i)")
                bg.name = "background_\(i)"
                bg.anchorPoint = CGPoint(x: 0, y: 0.5)
                bg.position = CGPoint(x: textureWidth * swapIndex , y: Int(scene.size.height)/2 + Int(Double(textureHeight) * 0.07))
                bg.size = CGSize(width: textureWidth, height: textureHeight)
                bg.zPosition = CGFloat(-6 + i)
                scene.addChild(bg)
            }
        }
       
        let topBarFill = SKSpriteNode(color: UIColor(red: 43/255, green: 87/255, blue: 84/255, alpha: 1.00), size: CGSize(width: scene.size.width, height: scene.size.height/2))
        topBarFill.name = "topBarFill"
        topBarFill.anchorPoint = .zero
        topBarFill.position = CGPoint(x: 0, y: scene.size.height/2)
        topBarFill.zPosition = -6
        scene.addChild(topBarFill)
        
        let bottomBarFill = SKSpriteNode(color: UIColor(red: 0.09, green: 0.17, blue: 0.23, alpha: 1.00), size: CGSize(width: scene.size.width, height: scene.size.height/2))
        topBarFill.name = "bottomBarFill"
        bottomBarFill.anchorPoint = .zero
        bottomBarFill.position = .zero
        bottomBarFill.zPosition = -6
        scene.addChild(bottomBarFill)
    }
    
    func moveBackground(_ scene: SKScene, speed: CGFloat) {
        for i in 2...5 {
            scene.enumerateChildNodes(withName: "background_\(i)") { (node, index) in
                let node = node as! SKSpriteNode
            
                let divisor = pow(2, Double(5 - (i - 1)))
                let adjustedSpeed = CGFloat(speed / divisor)
                let newPositionX = round(node.position.x - adjustedSpeed)
                
                node.position.x = newPositionX
                
                if node.position.x < -scene.frame.width {
                    node.position.x += 2 * scene.frame.width
                }
            }
        }
    }
    
}
