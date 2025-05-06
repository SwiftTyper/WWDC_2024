//
//  DataStorage.swift
//
//
//  Created by Wit Owczarek on 06/01/2024.
//

import Foundation

class DataStorage {
    
    static let sharedInstance = DataStorage()
    
    private init() {}
    
    static let keyHighScore = "keyHighScore"
    
    func setHighScore(_ highScore: Int){
        UserDefaults.standard.set(highScore, forKey: DataStorage.keyHighScore)
    }
    
    func getHighScore() -> Int{
        return UserDefaults.standard.integer(forKey: DataStorage.keyHighScore)
    }
    
}
