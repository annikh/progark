//
//  GameScene.swift
//  HelicopterGame
//
//  Created by Anniken Holst on 23.01.2018.
//  Copyright © 2018 Anniken Holst. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol IScoreObserver {
    
    var score1: SKLabelNode { get }
    var score2: SKLabelNode { get }
    func scoreUpdated(newScore: Int, playerNumber: Int)
    
}

class ScoreBoard: IScoreObserver {
    
    
    var score1 = SKLabelNode()
    var score2 = SKLabelNode()
    
    init() {
        score1.text = "0"
        score2.text = "0"
    }
    
    func scoreUpdated(newScore: Int, playerNumber: Int) {
        if playerNumber == 1 {
            score1.text = "\(newScore)"
        } else if playerNumber == 2 {
            score2.text = "\(newScore)"
        }
    }
}

class Ball: SKSpriteNode {
    
    static let INSTANCE = Ball()
    
    private init() { //the constructor is private, so it cannot be called. Hence the object cannot be initialized several times.
        let texture = SKTexture(imageNamed: "ping_pong")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let BallCategory      : UInt32 = 0x1 << 0
    let TopWallCategory   : UInt32 = 0x1 << 1
    let BottomWallCategory: UInt32 = 0x1 << 2
    
    private var observerArray = [IScoreObserver]()
    var ball = Ball.INSTANCE
    var paddle1 = SKSpriteNode(imageNamed: "pong_paddle_white")
    var paddle2 = SKSpriteNode(imageNamed: "pong_paddle_white")
    var textLabel = SKLabelNode()
    var replayLabel = SKLabelNode()
    var touchPoint = CGPoint()
    var touchingPaddle1 = false
    var touchingPaddle2 = false
    var started = false
    var gameOver = false
    var scoreBoard = ScoreBoard()
    
    private var _score1Value = 0
    var score1Value : Int {
        set {
            _score1Value = newValue
            notifyScoreChanged(newScore: newValue, playerNumber: 1)
        }
        get {
            return _score1Value
        }
    }
    
    private var _score2Value = 0
    var score2Value : Int {
        set {
            _score2Value = newValue
            notifyScoreChanged(newScore: newValue, playerNumber: 2)
        }
        get {
            return _score2Value
        }
    }
    
    
    func attachObserver(observer : IScoreObserver){
        observerArray.append(observer)
    }
    
    private func notifyScoreChanged(newScore: Int, playerNumber: Int){
        for observer in observerArray {
            observer.scoreUpdated(newScore: newScore, playerNumber: playerNumber)
        }
    }
    
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
        self.paddle1.physicsBody = SKPhysicsBody(rectangleOf: self.paddle1.size)
        self.paddle1.physicsBody?.isDynamic = false
        self.paddle1.physicsBody?.friction = 0
        self.paddle1.name = "paddle1"
        addChild(self.paddle1)
        
        //place paddle2 on the screen and give it a physics body
        self.paddle2.position = CGPoint(x: frame.origin.x + self.paddle2.size.width, y: frame.origin.y + self.paddle2.size.height)
        self.paddle2.physicsBody = SKPhysicsBody(rectangleOf: self.paddle1.size)
        self.paddle2.physicsBody?.isDynamic = false
        self.paddle2.physicsBody?.friction = 0
        self.paddle2.name = "paddle2"
        addChild(self.paddle2)
        
        //place start text on the middle of the screen
        self.textLabel.text = "TAP THE SCREEN TO START!"
        self.textLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 + self.ball.size.height * 2)
        addChild(self.textLabel)
        self.replayLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2 - self.ball.size.height * 2)
        addChild(self.replayLabel)
        
        //add scores to the screen
        attachObserver(observer: scoreBoard)
        let score1 = scoreBoard.score1
        let score2 = scoreBoard.score2
        score1.position = CGPoint(x: frame.size.width - 25, y: frame.size.height/2 + 20)
        score2.position = CGPoint(x: frame.size.width - 25, y: frame.size.height/2 - 20)
        addChild(score1)
        addChild(score2)
        
        
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
            
            self.ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0)) //make the ball start moving since that game has started
        }
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == "paddle1" {
                touchingPaddle1 = true
            } else if body.node!.name == "paddle2" {
                touchingPaddle2 = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touchingPaddle1 {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            //compute difference between new and old paddle position
            var paddle1X = paddle1.position.x + (touchLocation.x - previousLocation.x)
            //limit the paddle position so that it cannot move off screen
            paddle1X = max(paddle1X, paddle1.size.width/2)
            paddle1X = min(paddle1X, size.width - paddle1.size.width/2)
            //change paddle position
            paddle1.position = CGPoint(x: paddle1X, y: paddle1.position.y)
        } else if touchingPaddle2 {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            //compute difference between new and old paddle position
            var paddle2X = paddle2.position.x + (touchLocation.x - previousLocation.x)
            //limit the paddle position so that it cannot move off screen
            paddle2X = max(paddle2X, paddle2.size.width/2)
            paddle2X = min(paddle2X, size.width - paddle2.size.width/2)
            //change paddle position
            paddle2.position = CGPoint(x: paddle2X, y: paddle2.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingPaddle1 = false
        touchingPaddle2 = false
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
            self.ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        } else if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomWallCategory {
            resetBall()
            self.score1Value += 1
            self.ball.physicsBody!.applyImpulse(CGVector(dx: -2.0, dy: 2.0))
        }
    }
    
}
