//
//  MenuScene.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-29.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MenuScene: SKScene {
    
    // Start button
    var start_btn : SKNode?
    
    // Play background music
    var bgSoundPlayer:AVAudioPlayer?
    
    override func sceneDidLoad() {
        bgSoundPlayer = AVAudioPlayer.menuBackgroundMusic
        bgSoundPlayer?.volume = 0.5
        bgSoundPlayer!.numberOfLoops = -1 // loop forever
        bgSoundPlayer!.play() // actually play
        
        start_btn = childNode(withName: "start_btn")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (start_btn?.contains(location))! {
                let level1 = Level2(fileNamed: "Level2")
                self.view?.presentScene(level1)
                self.removeAllActions()
            }
        }
    }
}
