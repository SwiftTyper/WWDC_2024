//
//  HUD.swift
//
//
//  Created by Wit Owczarek on 06/01/2024.
//

import SpriteKit

enum HUDSettings {
    static let score = "Score"
    static let highscore = "Highscore"
    static let tapToStart = "Tap To Start"
    static let gameOver = "Game Over"
}

class HUD: SKNode {
    
    var scoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(_ name: String, text: String, fontSize: CGFloat, pos: CGPoint) {
        let label = SKLabelNode()
        label.fontName = "PixeloidSans-Bold"
        label.name = name
        label.text = text
        label.fontSize = fontSize
        label.position = pos
        label.zPosition = 50.0
        addChild(label)
    }
    
    func setupScoreLabel(_ score: Int) {
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: 30.0, y: scene.size.height - 30)
        addLabel(HUDSettings.score, text: "SCORE: \(score)", fontSize: 30, pos: pos)
        scoreLabel = childNode(withName: HUDSettings.score) as? SKLabelNode
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
    }
    
    func setupHighscoreLabel(_ highscore: Int) {
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: scene.size.width - 30.0, y: scene.size.height - 30)
        addLabel(HUDSettings.highscore, text: "HIGHSCORE: \(highscore)", fontSize: 30, pos: pos)
        highscoreLabel = childNode(withName: HUDSettings.highscore) as? SKLabelNode
        highscoreLabel.horizontalAlignmentMode = .right
        highscoreLabel.verticalAlignmentMode = .top
    }
    
    func setupLabels(scene: GameScene) {
        scene.addChild(self)
        setupScoreLabel(scene.scoreValue)
        setupHighscoreLabel(scene.highscoreValue)
    }
}

