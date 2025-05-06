//
//  GameScene.swift
//
//
//  Created by Wit Owczarek on 01/01/2024.
//

import Foundation
import SpriteKit
import SwiftUI
import GameplayKit
import AVFoundation
import Combine

class GameScene: SKScene {
    
    init(size: CGSize, viewModel: PredictionViewModel) {
        self.viewModel = viewModel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: PredictionViewModel
    var previousPlayerState: String? = nil
    var cancellables = Set<AnyCancellable>()
    
    var player = Player()
    var ground = Ground()
    var background = Background()
    var obstacles = Obstacle()
    var coin = Coin()
    var hud = HUD()
    var health = Health()
    
    var playerStateController: GKStateMachine!
    var scoreValue: Int = 0
    var highscoreValue: Int = DataStorage.sharedInstance.getHighScore()
    
    var velocityX = 6.0
    var difficultyTimer: Timer?
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupPhysics()
        setupPlayerState()
        setupPlayerStateObserver()
    }
    
    func setupPlayerStateObserver() {
        viewModel.$predicted
            .sink(receiveValue: { [weak self] newState in
                self?.handlePlayerStateChanged(to: newState)
            })
            .store(in: &cancellables)
    }
    
    func handlePlayerStateChanged(to playerState: String) {
        
        if (playerState == PushupClassifierV3.Label.pushupUp.rawValue || playerState == PushupClassifierV3.Label.pushupUpHold.rawValue) &&
            (previousPlayerState == nil || previousPlayerState == PushupClassifierV3.Label.pushupDownHold.rawValue || previousPlayerState == PushupClassifierV3.Label.pushupDown.rawValue)
        {
            if playerStateController.canEnterState(JumpingState.self) {
                run(Sound.jump.action)
            }
            playerStateController.enter(JumpingState.self)
        }
        
        previousPlayerState = playerState
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let bool = self.scene?.isPaused, bool {
            resumeGame()
        } else {
            pauseGame()
        }
    }
}


//MARK: Game Loop
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        ground.moveGround(self, speed: velocityX)
        background.moveBackground(self, speed: velocityX)
        obstacles.moveObstacles(scene: self)
        coin.moveCoins(scene: self)
        playerStateController.enter(WalkingState.self)
    }
}

//MARK: Configuration
extension GameScene {
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    func setupNodes() {
        ground.setupGround(self)
        background.setupBackground(self)
        player.setupPlayer(ground, scene: self)
        obstacles.setupObstacles(scene: self)
        hud.setupLabels(scene: self)
        health.fillHearts(scene: self)
     
        AudioPlayerManager.shared.playBackgroundMusic()
        updateDifficulty()
    }
    
    func setupPlayerState() {
        playerStateController = GKStateMachine(states: [
            JumpingState(playerNode: player),
            WalkingState(playerNode: player),
            IdleState(playerNode: player),
            LandingState(playerNode: player),
            StunnedState(playerNode: player)
        ])
        
        playerStateController.enter(IdleState.self)
    }
    
    func updateDifficulty() {
        difficultyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseVelocity), userInfo: nil, repeats: true)
    }
     
    @objc func increaseVelocity(){
        if velocityX <= 8 {
            velocityX += 0.01
        }
    }
}

//MARK: Collisions
extension GameScene: SKPhysicsContactDelegate {
    
    struct Collision {
        enum Masks: Int {
            case killing, player, reward, ground
            
            var bitmask: UInt32 {
                return 1<<self.rawValue
            }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks, _ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) || (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
    
        if collision.matches(.player, .killing) {
            handleTrapCollision()
        } else if collision.matches(.player, .ground) {
            playerStateController.enter(LandingState.self)
        } else if collision.matches(.player, .reward) {
            handleRewardCollision(contact)
        }
    }
    
    func pauseGame() {
        viewModel.stopConditionMonitoring()
        
        let button = SKSpriteNode(texture: .init(imageNamed: "pause"))
        button.name = "pause"
        button.anchorPoint = .init(x: 0.5, y: 0.5)
        button.position = .init(x: self.size.width/2, y: self.size.height/2)
        button.zPosition = 6
        button.size = CGSize(width: 200, height: 200)
        addChild(button)
        
        let blurEffectNode = SKEffectNode()
        blurEffectNode.name = "blur"
        blurEffectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 10.0])
        blurEffectNode.position = CGPoint(x: 0, y: 0)
        blurEffectNode.blendMode = .alpha
        blurEffectNode.shouldEnableEffects = true
        blurEffectNode.shouldRasterize = true
        blurEffectNode.zPosition = 5
        
        if self.scene != nil {
            let texture = self.view?.texture(from: self.scene!)
            let fullscreenSprite = SKSpriteNode(texture: texture)
            fullscreenSprite.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            fullscreenSprite.zPosition = 1
            blurEffectNode.addChild(fullscreenSprite)
        }

        addChild(blurEffectNode)
        
        self.scene?.isPaused = true
    }
    
    func resumeGame() {
        viewModel.setupConditionMonitoring()
        
        self.scene?.enumerateChildNodes(withName: "blur", using: { node, _ in
            node.removeFromParent()
        })
        
        self.scene?.enumerateChildNodes(withName: "pause", using: { node, _ in
            node.removeFromParent()
        })
        
        self.scene?.isPaused = false
    }
    
    func setupGameOver() {
        playerStateController.enter(StunnedState.self)
        let isNewHighscore = scoreValue > highscoreValue
        
        if isNewHighscore {
            highscoreValue = scoreValue
            DataStorage.sharedInstance.setHighScore(scoreValue)
        }
        
        difficultyTimer?.invalidate()
        player.removeFromParent()
        self.removeAllActions()
    
        viewModel.isGameOver = true
        viewModel.stopConditionMonitoring()
        let gameOverScene = GameOverScene(size: self.size, isHighscore: isNewHighscore, viewModel: viewModel)
        let transition = SKTransition.crossFade(withDuration: 0.5)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    
    func handleRewardCollision(_ contact: SKPhysicsContact) {
        var coinNode: SKNode?

        if contact.bodyA.node?.name == "coin" {
           coinNode = contact.bodyA.node
        } else if contact.bodyB.node?.name == "coin" {
           coinNode = contact.bodyB.node
        }

        if let coin = coinNode, coin.userData?["collected"] as? Bool != true {
           coin.removeFromParent()
           coin.userData?["collected"] = true

           run(Sound.reward.action)
           scoreValue += 1
           hud.scoreLabel?.text = "SCORE: \(scoreValue)"
        }
    }
    
    func handleTrapCollision() {
        health.loseHeart(scene: self)
    }
}


