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
        //create a URL variable using the name variable and tacking on the "wav" extension
        let fileURL: URL = Bundle.main.url(forResource:"music", withExtension: "wav")!
        
        //Try to initialize the bgSoundPlayer with the contents of the URL
        do {
            return try AVAudioPlayer(contentsOf: fileURL)
        } catch _{
            return nil
        }
    }
}
