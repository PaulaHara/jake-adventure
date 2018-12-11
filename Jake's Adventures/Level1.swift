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
    
//    var flyMan : SKNode?
    
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
        
//        flyMan = childNode(withName: "enemies")
//        
//        // Animate flyMan
//        let y: CGFloat = (flyMan?.position.y)!;
//        let a = SKAction.moveTo(y: y+50, duration:1.0);
//        let b = SKAction.moveTo(y: y-20, duration:1.0);
//        let c = SKAction.sequence([a, b]);
//        let d = SKAction.repeatForever(c)
//        self.flyMan?.run(d)
        
        
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
