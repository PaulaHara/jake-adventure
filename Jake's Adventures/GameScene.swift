//
//  GameScene.swift
//  Jake's Adventures
//
//  Created by paula on 2018-11-16.
//  Copyright © 2018 paula. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    // Nodes
    var player : SKNode?
    var joystick : SKNode?
    var joystickKnob : SKNode?
    var cameraNode : SKCameraNode?
    var mountain1 : SKNode?
    var mountain2 : SKNode?
    var mountain3 : SKNode?
    var moon : SKNode?
    var stars : SKNode?
    var scenario : SKNode?
    var backgroundNode : SKNode?
    var goNextLevel : SKNode?
    var outOfMap : SKNode?
    var flyMan : SKNode?
    
    // Boolean
    var joystickAction = false
    var rewardIsNotTouched = true
    var isHit = false
    var goToNextLevel = false
    var isInvicible = false
    var carrotIsNotTouched = false
    
    // Meassure
    var knobRadius : CGFloat = 50.0
    
    // Score
    let scoreLabel = SKLabelNode()
    var score = 0
    
    // Hearts
    var heartsArray = [SKSpriteNode]()
    let heartContainer = SKSpriteNode()
    
    // Sprite Engine
    var playerIsFacingRight = true
    var playerSpeed = 1.0
    
    // Player state
    var playerStateMachine: GKStateMachine!
    
    var bgSoundPlayer:AVAudioPlayer? //add this
    
    // DidMove
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Play background music
        bgSoundPlayer = AVAudioPlayer.backgroundMusic
        bgSoundPlayer?.volume = 0.5
        bgSoundPlayer!.numberOfLoops = -1 // loop forever
        bgSoundPlayer!.play() // actually play
        
        player = childNode(withName: "player") as? SKSpriteNode
        joystick = childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        mountain1 = childNode(withName: "mountains1")
        mountain2 = childNode(withName: "mountains2")
        mountain3 = childNode(withName: "mountains3")
        moon = childNode(withName: "moon")
        stars = childNode(withName: "stars")
        backgroundNode = childNode(withName: "backgroundNode")
        goNextLevel = childNode(withName: "GoNextLevel")
        outOfMap = childNode(withName: "killingGround")
        flyMan = childNode(withName: "enemies")
        
        // Animate flyMan
        let y: CGFloat = (flyMan?.position.y)!;
        let a = SKAction.moveTo(y: y+50, duration:2.0);
        let b = SKAction.moveTo(y: y-20, duration:2.0);
        let c = SKAction.sequence([a, b]);
        let d = SKAction.repeatForever(c)
        flyMan?.run(d)
        
        playerStateMachine = GKStateMachine(states: [
            JumpingState(playerNode: player!),
            WalkingState(playerNode: player!),
            IdleState(playerNode: player!),
            LandingState(playerNode: player!),
            StunnedState(playerNode: player!),
            ])
        
        playerStateMachine.enter(IdleState.self)
        
        // Hearts
        heartContainer.position = CGPoint(x: -300, y: 140)
        heartContainer.zPosition = 5
        cameraNode?.addChild(heartContainer)
        fillHearts(count: 3)
        
        // Timer
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {(timer) in
            self.spawnMeteor()
        }
        
        scoreLabel.position = CGPoint(x: (cameraNode?.position.x)! + 310, y: 140)
        scoreLabel.fontColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        scoreLabel.fontSize = 24
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.text = String(score)
        cameraNode?.addChild(scoreLabel)
    }
}

// MARK: Touches
extension GameScene {
    // Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let joystickKnob = joystickKnob {
                let location = touch.location(in: joystick!)
                joystickAction = joystickKnob.frame.contains(location)
            }
            
            let location = touch.location(in: self)
            if !(joystick?.contains(location))! {
                playerStateMachine.enter(JumpingState.self)
                run(Sound.jump.action)
            }
        }
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        
        if !joystickAction { return }
        
        // Distance
        for touch in touches {
            let position = touch.location(in: joystick)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y, position.x)
            
            if knobRadius > length {
                joystickKnob.position = position
            } else {
                joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    // Touch Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xJoystickCoordinate = touch.location(in: joystick!).x
            let xLimit: CGFloat = 200.0
            if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
                resetKnobPosition()
            }
        }
    }
}

// MARK: Action
extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
    
    func rewardTouch() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    fileprivate func addHeart(_ index: Int) {
        let heart = SKSpriteNode(imageNamed: "heart")
        let xPosition = heart.size.width * CGFloat(index - 1)
        heart.position = CGPoint(x: xPosition, y: 0)
        heartsArray.append(heart)
        heartContainer.addChild(heart)
    }
    
    func fillHearts(count: Int) {
        for index in 1...count {
            addHeart(index)
        }
    }
    
    func loseHeart() {
        if isHit {
            let lastElementIndex = heartsArray.count - 1
            if heartsArray.indices.contains(lastElementIndex - 1) {
                let lastHeart = heartsArray[lastElementIndex]
                lastHeart.removeFromParent()
                heartsArray.remove(at: lastElementIndex)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) {(timer) in
                    self.isHit = false
                }
            } else {
                dying()
                showDieScene()
            }
            invincible()
        }
    }
    
    func receiveHeart() {
        let lastElementIndex = heartsArray.count
        if heartsArray.count < 3 {
            addHeart(lastElementIndex + 1)
        }
    }
    
    func invincible() {
        isInvicible = true
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {(timer) in
            self.isInvicible = false
        }
    }
    
    func dying() {
        let dieAction = SKAction.move(to: CGPoint(x: -300, y: 0), duration: 0.1)
        player?.run(dieAction)
        self.removeAllActions()
        fillHearts(count: 3)
    }
    
    func showDieScene() {
        bgSoundPlayer?.stop()
        
        let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
        self.view?.presentScene(gameOverScene)
    }
}

// MARK: Game Loop
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        rewardIsNotTouched = true
        carrotIsNotTouched = true
        
        // Camera
        cameraNode?.position.x = player!.position.x + 50
        joystick?.position.y = (cameraNode?.position.y)! - 100
        joystick?.position.x = (cameraNode?.position.x)! - 300

        // Player movement
        guard let joystickKnob = joystickKnob else { return }
        let xPosition = Double(joystickKnob.position.x)
        let positivePosition = xPosition < 0 ? -xPosition : xPosition
        
        if floor(positivePosition) != 0 {
            playerStateMachine.enter(WalkingState.self)
        } else {
            playerStateMachine.enter(IdleState.self)
        }
        
        let displacement = CGVector(dx: xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        let faceAction : SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -0.5, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 0.5, duration: 0.0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player?.run(faceAction)
        
        // Background Parallax
        let parallax1 = SKAction.moveTo(x: (player?.position.x)!/(-10), duration: 0.0)
        mountain1?.run(parallax1)
        
        let parallax2 = SKAction.moveTo(x: (player?.position.x)!/(-20), duration: 0.0)
        mountain2?.run(parallax2)
        
        let parallax3 = SKAction.moveTo(x: (player?.position.x)!/(-40), duration: 0.0)
        mountain3?.run(parallax3)
        
        let parallax4 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        moon?.run(parallax4)
        
        let parallax5 = SKAction.moveTo(x: (cameraNode?.position.x)!, duration: 0.0)
        stars?.run(parallax5)        
    }
}

// MARK: Collision
extension GameScene: SKPhysicsContactDelegate {
    struct Collision {
        enum Masks: Int {
            case killing, player, reward, ground, nextLevel, outOfMap
            var bitmask: UInt32 {
                return 1 << self.rawValue
            }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches (_ first: Masks, _ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
                (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))

        if collision.matches(.player, .killing) {
            if !isInvicible {
                isHit = true
                loseHeart()
                
                var nodeToRemove = SKNode()
                if contact.bodyA.node?.name == "spikeBall" {
                    nodeToRemove = contact.bodyA.node!
                } else if contact.bodyB.node?.name == "spikeBall" {
                    nodeToRemove = contact.bodyB.node!
                }
                nodeToRemove.physicsBody?.categoryBitMask = 0
                nodeToRemove.removeFromParent()
                 
                run(Sound.hit.action)
                
                playerStateMachine.enter(StunnedState.self)
            }
        }
        
        if collision.matches(.player, .ground) {
            playerStateMachine.enter(LandingState.self)
        }
        
        if collision.matches(.player, .reward) {
            var nodeToRemove = SKNode()
            var touchedCoin = false
            var touchedCarrot = false
            
            if contact.bodyA.node?.name == "Jewel" {
                nodeToRemove = contact.bodyA.node!
                touchedCoin = true
            } else if contact.bodyB.node?.name == "Jewel" {
                nodeToRemove = contact.bodyB.node!
                touchedCoin = true
            }
            
            if contact.bodyA.node?.name == "carrot" {
                nodeToRemove = contact.bodyA.node!
                touchedCarrot = true
            } else if contact.bodyB.node?.name == "carrot" {
                nodeToRemove = contact.bodyB.node!
                touchedCarrot = true
            }
            
            nodeToRemove.physicsBody?.categoryBitMask = 0
            nodeToRemove.removeFromParent()
            
            if rewardIsNotTouched {
                if touchedCoin {
                    rewardTouch()
                }
                if touchedCarrot{
                    receiveHeart()
                }
                rewardIsNotTouched = false
            }
            run(Sound.reward.action)
        }
        
        if collision.matches(.player, .nextLevel) {
            if contact.bodyA.node?.name == "GoNextLevel" || contact.bodyB.node?.name == "GoNextLevel"{
                goToNextLevel = true
            }
        }
        
        if collision.matches(.player, .outOfMap) || collision.matches(.player, .outOfMap) {
            showDieScene()
        }
    }
}

// MARK: Meteor
extension GameScene {
    func spawnMeteor() {
        let node = SKSpriteNode(imageNamed: "spikeBall/0")
        node.name = "spikeBall"
        
        node.position = CGPoint(x: (player?.position.x)! + 400, y: 10)
        node.anchorPoint = CGPoint(x: 0.5, y: 1)
        node.zPosition = 5
        node.xScale = 0.3
        node.yScale = 0.3
        
        let physicsBody = SKPhysicsBody(circleOfRadius: 30)
        node.physicsBody = physicsBody
        
        physicsBody.categoryBitMask = Collision.Masks.killing.bitmask
        physicsBody.collisionBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        physicsBody.contactTestBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        physicsBody.fieldBitMask = Collision.Masks.player.bitmask | Collision.Masks.ground.bitmask
        
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.2
        physicsBody.friction = 10
        
        addChild(node)
    }
}
