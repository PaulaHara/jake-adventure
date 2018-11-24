//
//  Sound.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-19.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
  
enum Sound: String {
    case hit, jump, levelUp, meteorFalling, reward
    
    var action: SKAction {
        return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
    }
}

extension AVAudioPlayer {
    static var backgroundMusic: AVAudioPlayer? {
        let fileURL: URL = Bundle.main.url(forResource:"music", withExtension: "wav")!
        
        do {
            return try AVAudioPlayer(contentsOf: fileURL)
        } catch {
            return nil
        }
    }
}
