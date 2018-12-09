//
//  Level2.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-19.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class Level2: GameScene {
    
    var clouds : SKNode?
    var transparent : SKNode?
    
    var spikeBall : SKNode?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        clouds = childNode(withName: "clouds")
        transparent = childNode(withName: "transparent_blue")
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
        
        spikeBall = childNode(withName: "spikeBalls")
        
        // Animate spikeBall
        let y: CGFloat = (spikeBall?.position.y)!;
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {(timer) in
            let a = SKAction.moveTo(y: y+50, duration:1.0);
            let b = SKAction.moveTo(y: y-30, duration:1.0);
            let c = SKAction.sequence([a, b]);
            let d = SKAction.repeatForever(c)
            self.spikeBall?.run(d)
        }
        
        let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        clouds?.run(parallax4)
        
        let parallax5 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        transparent?.run(parallax5)  
    }
}
