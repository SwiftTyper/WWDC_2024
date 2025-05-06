//
//  GameOverScene.swift
//
//
//  Created by Wit Owczarek on 01/01/2024.
//

import Foundation
import SpriteKit
import SwiftUI

class GameOverScene: SKScene{
    
    let background = Background()
    let ground = Ground()
    let containerNode = SKScene()
    
    
    var previousTime: TimeInterval = 0
    var minimumDifference: TimeInterval = 0.02
    var isHighscore: Bool
    var viewModel: PredictionViewModel
    
    private var blurEffectNode: SKEffectNode?
    private var restartButton: SKSpriteNode?
    
    init(size: CGSize, isHighscore: Bool, viewModel: PredictionViewModel) {
        self.isHighscore = isHighscore
        self.viewModel = viewModel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Actions
extension GameOverScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        if nodes.contains(where: { $0 == restartButton }) {
            viewModel.showOnboarding = true
            viewModel.isShowingGame = false
            viewModel.isGameOver = false
            DataStorage.sharedInstance.setHighScore(0)
            AudioPlayerManager.shared.stopAudio()
            viewModel.setupConditionMonitoring()
        } else {
            let scene = GameScene(size: self.size, viewModel: viewModel)
            scene.scaleMode = scaleMode
            viewModel.isGameOver = false
            viewModel.isShowingGame = false
            AudioPlayerManager.shared.stopAudio()
            viewModel.setupConditionMonitoring()
            view!.presentScene(scene)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentTime - previousTime > minimumDifference {
            previousTime = currentTime
            background.moveBackground(containerNode, speed: 4)
            ground.moveGround(containerNode, speed: 4)
            updateBlurEffectNodeTexture()
        }
    }
    
     func updateBlurEffectNodeTexture() {
         let texture = self.view?.texture(from: containerNode)
         let fullscreenSprite = SKSpriteNode(texture: texture)
         fullscreenSprite.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
         fullscreenSprite.zPosition = 1

         self.blurEffectNode?.children.forEach { $0.removeFromParent() }
         self.blurEffectNode?.addChild(fullscreenSprite)
     }
}

//MARK: -Configurations
extension GameOverScene {
    
    override func didMove(to view: SKView) {
        if isHighscore {
            run(Sound.record.action)
        } else {
            run(Sound.death.action)
        }
        setupContainer()
        setupNodes()
        setupBlurNode()
        setupRestartButton()
    }
    
    func setupNodes() {
        ground.setupGround(containerNode)
        background.setupBackground(containerNode)
        setupLabels()
    }
    
    func setupBlurNode() {
        blurEffectNode = SKEffectNode()
        blurEffectNode?.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 10.0])
        blurEffectNode?.position = CGPoint(x: 0, y: 0)
        blurEffectNode?.blendMode = .alpha
        blurEffectNode?.shouldEnableEffects = true
        blurEffectNode?.shouldRasterize = true

        updateBlurEffectNodeTexture()

        if let blurNode = blurEffectNode {
            addChild(blurNode)
        }
    }
    
    func setupRestartButton() {
        restartButton = SKSpriteNode(texture: .init(imageNamed: "restart"))
        restartButton?.size = CGSize(width: 40, height: 40)
        restartButton?.position = CGPoint(x: frame.maxX - 70, y: frame.minY + 70)
        restartButton?.xScale = -1
        restartButton?.name = "restartButton"
        addChild(restartButton!)
    }
    
    func setupLabels(){
        let gameOverLabel = SKLabelNode(fontNamed: MyCustomFonts.main.fontName)
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 120
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.zPosition = 50.0
        gameOverLabel.position = CGPoint (x: frame.midX, y: frame.midY + 50)
        
        addChild(gameOverLabel)
        
        if isHighscore {
            let highscoreFontSize: CGFloat = 30
            
            let highscoreLabel = SKLabelNode(fontNamed: MyCustomFonts.main.fontName)
            highscoreLabel.text = "NEW HIGHSCORE"
            highscoreLabel.fontSize = highscoreFontSize
          
            highscoreLabel.zPosition = 50.0
            highscoreLabel.horizontalAlignmentMode = .center
            highscoreLabel.verticalAlignmentMode = .center
            highscoreLabel.position = CGPoint(x: gameOverLabel.frame.width/2-16, y: gameOverLabel.frame.height/2-16)
            highscoreLabel.zRotation = CGFloat(-30).rad2deg()
        
            let backgroundNode = SKSpriteNode(color: .red, size: CGSize(width: highscoreLabel.frame.width + highscoreFontSize, height: highscoreFontSize))
            backgroundNode.position = CGPoint(x: gameOverLabel.frame.width/2-16, y: gameOverLabel.frame.height/2-16)
            backgroundNode.zRotation = CGFloat(-30).rad2deg()
            backgroundNode.zPosition = highscoreLabel.zPosition - 1
        
            gameOverLabel.addChild(backgroundNode)
            gameOverLabel.addChild(highscoreLabel)
        }
        
        let gameoverFontSize: CGFloat = 30.0
        let gameOverSubLable = SKLabelNode(fontNamed: MyCustomFonts.main.fontName)
        gameOverSubLable.text = "TAP ANYWHERE TO CONTINUE"
        gameOverSubLable.fontSize = gameoverFontSize
        gameOverSubLable.horizontalAlignmentMode = .center
        gameOverSubLable.verticalAlignmentMode = .center
        gameOverSubLable.zPosition = 40.0
        gameOverSubLable.position = CGPoint(x: frame.midX, y: frame.midY - (gameOverLabel.frame.height + gameoverFontSize) * 0.5)
        addChild(gameOverSubLable)
        
        highscoreAnimation(node: gameOverLabel)
    }
    
    func setupContainer(){
        containerNode.name = "container"
        containerNode.zPosition = 15.0
        containerNode.size = size
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
    }
    
    func highscoreAnimation(node: SKNode){
        let scaleUp = SKAction.scale(to: 1.1, duration: 1.0)
        scaleUp.timingMode = .easeInEaseOut
        
        let scaleDown = SKAction.scale(to: 0.9, duration: 1.0)
        scaleDown.timingMode = .easeInEaseOut
        
        let fullScale = SKAction.sequence([scaleUp, scaleDown])
        node.run(.repeatForever(fullScale))
    }
}


