//
//  GameScene.swift
//  HelicopterGame
//
//  Created by Anniken Holst on 23.01.2018.
//  Copyright © 2018 Anniken Holst. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory      : UInt32 = 0x1 << 0
    let TopWallCategory   : UInt32 = 0x1 << 1
    let BottomWallCategory: UInt32 = 0x1 << 2
    
    var ball = SKSpriteNode(imageNamed: "ping_pong")
    var paddle1 = SKSpriteNode(imageNamed: "pong_paddle_white")
    var paddle2 = SKSpriteNode(imageNamed: "pong_paddle_white")
    var textLabel = SKLabelNode()
    var replayLabel = SKLabelNode()
    var score1Value = 0
    var score2Value = 0
    var score1 = SKLabelNode()
    var score2 = SKLabelNode()
    var touchPoint = CGPoint()
    var touchingPaddle1 = false
    var touchingPaddle2 = false
    var started = false
    var gameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        //place ball and give it a physics body
        self.ball.size = CGSize(width: self.ball.size.width * 0.2, height: self.ball.size.height * 0.2)
        self.ball.physicsBody = SKPhysicsBody(rectangleOf: self.ball.size)
        self.ball.physicsBody?.mass = 0.01
        self.ball.physicsBody?.allowsRotation = false
        self.ball.physicsBody?.friction = 0
        self.ball.physicsBody?.restitution = 1
        self.ball.physicsBody?.linearDamping = 0
        self.ball.physicsBody?.angularDamping = 0
    
        self.ball.position = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        addChild(self.ball)
    
        
        //place paddle1 on the screen and give it a physics body
        self.paddle1.position = CGPoint(x: frame.origin.x + self.paddle1.size.width, y: frame.origin.y + frame.size.height - self.paddle1.size.height)
        addChild(self.paddle1)
        self.paddle1.physicsBody = SKPhysicsBody(rectangleOf: self.paddle1.size)
        self.paddle1.physicsBody?.isDynamic = false
        self.paddle1.physicsBody?.friction = 0
        
        //place paddle2 on the screen and give it a physics body
        self.paddle2.position = CGPoint(x: frame.origin.x + self.paddle2.size.width, y: frame.origin.y + self.paddle2.size.height)
        addChild(self.paddle2)
        self.paddle2.physicsBody = SKPhysicsBody(rectangleOf: self.paddle1.size)
        self.paddle2.physicsBody?.isDynamic = false
        self.paddle2.physicsBody?.friction = 0
        
        
        //place start text on the middle of the screen
        self.textLabel.text = "TAP THE SCREEN TO START!"
        self.textLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + self.ball.size.height * 2)
        addChild(self.textLabel)
        self.replayLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 - self.ball.size.height * 2)
        addChild(self.replayLabel)
        
        //add scores to the screen
        self.score1.position = CGPoint(x: frame.size.width - 25, y: frame.size.height/2 + 20)
        self.score2.position = CGPoint(x: frame.size.width - 25, y: frame.size.height/2 - 20)
        addChild(self.score1)
        addChild(self.score2)
        
        
        let topWallRect = CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height, width: frame.size.width, height: -1)
        let topWall = SKNode()
        topWall.physicsBody = SKPhysicsBody(edgeLoopFrom: topWallRect)
        addChild(topWall)
        
        let bottomWallRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottomWall = SKNode()
        bottomWall.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomWallRect)
        addChild(bottomWall)
        
        let leftWallRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: 1, height: frame.size.height)
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeLoopFrom: leftWallRect)
        addChild(leftWall)
        
        let rightWallRect = CGRect(x: frame.origin.x + self.frame.size.width, y: frame.origin.y, width: 1, height: frame.size.height)
        let rightWall = SKNode()
        rightWall.physicsBody = SKPhysicsBody(edgeLoopFrom: rightWallRect)
        addChild(rightWall)
        
        self.ball.physicsBody!.categoryBitMask = BallCategory
        topWall.physicsBody!.categoryBitMask = TopWallCategory
        bottomWall.physicsBody!.categoryBitMask = BottomWallCategory
        
        self.ball.physicsBody!.contactTestBitMask = BottomWallCategory | TopWallCategory
        
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !started {
            self.textLabel.isHidden = true
            self.replayLabel.isHidden = true
            self.started = true
            self.score1Value = 0
            self.score2Value = 0
            self.score1.text = "\(score1Value)"
            self.score2.text = "\(score2Value)"
            self.ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0)) //make the ball start moving since that game has started
        }
        
        /*let touch = touches.first!
        let location = touch.location(in: self)
        if self.paddle1.frame.contains(location) {
            touchPoint = location
            touchingPaddle1 = true
        } else if self.paddle2.frame.contains(location) {
            touchPoint = location
            touchingPaddle2 = true
        }*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*let touch = touches.first!
        let location = touch.location(in: self)
        touchPoint = location*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*touchingPaddle1 = false
        touchingPaddle2 = false*/
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.score2Value >= 21 || self.score1Value >= 21 {
            gameOver = true
            self.started = false
            self.textLabel.isHidden = false
            self.textLabel.text = "GAME OVER!"
            self.replayLabel.isHidden = false
            self.replayLabel.text = "TAP SCREEN TO PLAY AGAIN"
            resetBall()
        }
        
        /*if touchingPaddle1 {
            let dt: CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint.x - self.paddle1.position.x, dy: touchPoint.y - self.paddle1.position.y)
            let velocity = CGVector(dx: distance.dx/dt, dy: distance.dy/dt)
            self.paddle1.physicsBody!.velocity = velocity
        }*/
    }
    
    
    func resetBall() {
        self.ball.removeFromParent()
        self.ball.position = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y + frame.size.height/2)
        addChild(self.ball)
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == TopWallCategory {
            resetBall()
            self.score2Value += 1
            self.score2.text = "\(score2Value)"
            self.ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        } else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomWallCategory {
            resetBall()
            self.score1Value += 1
            self.score1.text = "\(score1Value)"
            self.ball.physicsBody!.applyImpulse(CGVector(dx: -2.0, dy: 2.0))
        }
    }
    
}
