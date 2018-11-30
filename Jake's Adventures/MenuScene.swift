//
//  MenuScene.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-29.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var start_btn : SKNode?
    
    override func sceneDidLoad() {
        start_btn = childNode(withName: "start_btn")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (start_btn?.contains(location))! {
                let level1 = GameScene(fileNamed: "Level1")
                self.view?.presentScene(level1)
                self.removeAllActions()
            }
        }
    }
}
