//
//  AudioPlayerManager.swift
//
//
//  Created by Wit Owczarek on 19/02/2024.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        configure()
    }
    
    func configure() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                options: AVAudioSession.CategoryOptions.mixWithOthers
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.audioPlayer = AVAudioPlayer()
            self.audioPlayer?.prepareToPlay()
            
        } catch {
            print("Error while configuring")
        }
    }
    
    func playSound(named name: String, withExtension ext: String = "mp3", numberOfLoops: Int = 1, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file \(name).\(ext) not found")
            return
        }
        
        do {
            if let currentPlayer = audioPlayer {
                currentPlayer.stop()
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = numberOfLoops
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound \(name): \(error.localizedDescription)")
        }
    }
    
    func playBackgroundMusic() {
        self.playSound(named: "background", numberOfLoops: -1, volume: 0.1)
    }
    
    func playCountdownSound() {
        self.playSound(named: "countdown", withExtension: "wav")
    }
    
    func stopAudio() {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
}
