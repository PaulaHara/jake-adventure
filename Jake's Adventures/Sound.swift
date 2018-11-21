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
    case hit, jump, levelUp, meteorFalling, reward, background
    
    var action: SKAction {
        return SKAction.playSoundFileNamed(rawValue + "Sound.wav", waitForCompletion: false)
    }
    
    var audioPlayer: AVAudioPlayer? {
        if let path = Bundle.main.path(forResource: "backgroundSound", ofType: ".wav") {
            let url = URL(fileURLWithPath: path)
            return try! AVAudioPlayer(contentsOf: url)
        }
        return nil
    }
}

extension SKAction {
    static let playGameMusic: SKAction = repeatForever(playSoundFileNamed("music.wav", waitForCompletion: false))
}
