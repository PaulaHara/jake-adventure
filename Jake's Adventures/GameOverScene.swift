//
//  GameOver.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-19.
//  Copyright © 2018 paula. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func sceneDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {(timer) in
            let level1 = GameScene(fileNamed: "Level1")
            self.view?.presentScene(level1)
            self.removeAllActions()
        }
    }
}
