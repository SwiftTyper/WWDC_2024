//
//  Sound.swift
//  
//
//  Created by Wit Owczarek on 06/01/2024.
//

import Foundation
import SpriteKit
import AVFAudio

enum Sound : String {
    case countdown = "countdown.wav"
    case death = "death.mp3"
    case jump = "jump.wav"
    case record = "record.mp3"
    case reward = "reward.wav"
    case boxcollision = "box crash.mp3"
    
    var action: SKAction {
        return SKAction.playSoundFileNamed(rawValue, waitForCompletion: false)
    }
}


