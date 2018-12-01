//
//  Level1.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-19.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Level1: GameScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if goToNextLevel {
            let action = SKAction.moveTo(x: (player?.position.x)!, duration: 0.0)
            player?.run(action)
            
            playerStateMachine.enter(JumpingState.self)
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {(timer) in
                self.bgSoundPlayer?.stop()
                
                let nextLevel = Level2(fileNamed: "Level2")
                nextLevel?.scaleMode = .aspectFill
                
                self.view?.presentScene(nextLevel)
                self.run(Sound.levelUp.action)
            }
        }
    }
}
