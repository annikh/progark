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
    
    let HeliCategory      : UInt32 = 0x1 << 0
    let LeftWallCategory  : UInt32 = 0x1 << 1
    let RightWallCategory : UInt32 = 0x1 << 2
    let BorderCategory    : UInt32 = 0x1 << 3
    
    var heli = SKSpriteNode(imageNamed: "heli1-flipped")
    var started = false
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        //run(SKAction.run(addHelicopter))
        self.heli.physicsBody = SKPhysicsBody(rectangleOf: heli.size)
        self.heli.physicsBody?.mass = 0.02
        self.heli.physicsBody?.allowsRotation = false
        self.heli.physicsBody?.friction = 0
        self.heli.physicsBody?.restitution = 1
        self.heli.physicsBody?.linearDamping = 0
        self.heli.physicsBody?.angularDamping = 0
        
        self.heli.position = CGPoint(x: frame.origin.x + heli.size.width, y: size.height - heli.size.height)
        addChild(self.heli)
        self.heli.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        
        
        let leftWallRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: 1, height: frame.size.height)
        let leftWall = SKNode()
        leftWall.physicsBody = SKPhysicsBody(edgeLoopFrom: leftWallRect)
        addChild(leftWall)
        
        let rightWallRect = CGRect(x: frame.origin.x + self.frame.size.width, y: frame.origin.y, width: 1, height: frame.size.height)
        let rightWall = SKNode()
        rightWall.physicsBody = SKPhysicsBody(edgeLoopFrom: rightWallRect)
        addChild(rightWall)
        
        self.heli.physicsBody!.categoryBitMask = HeliCategory
        borderBody.categoryBitMask = BorderCategory                     //TODO fjerne?
        leftWall.physicsBody!.categoryBitMask = LeftWallCategory
        rightWall.physicsBody!.categoryBitMask = RightWallCategory
        
        self.heli.physicsBody!.contactTestBitMask = RightWallCategory | LeftWallCategory
        
        }
    
    func addHelicopter() {
        
        self.heli.physicsBody = SKPhysicsBody(rectangleOf: heli.size)
        self.heli.physicsBody?.mass = 0.02
        self.heli.physicsBody?.allowsRotation = false
        self.heli.physicsBody?.friction = 0
        self.heli.physicsBody?.restitution = 1
        self.heli.physicsBody?.linearDamping = 0
        self.heli.physicsBody?.angularDamping = 0
        
        
        self.heli.position = CGPoint(x: size.width * 0.2, y: size.height)
        addChild(self.heli)
        self.heli.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
        self.started = true
        
    
       // heliMove(helicopter: heli)
       
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
        
        if firstBody.categoryBitMask == HeliCategory && secondBody.categoryBitMask == RightWallCategory {
            print("Hit right wall!")
            self.heli.texture = SKTexture(imageNamed: "heli1")
        } else if firstBody.categoryBitMask == HeliCategory && secondBody.categoryBitMask == LeftWallCategory {
            print("Hit left wall!")
            self.heli.texture = SKTexture(imageNamed: "heli1-flipped")
        }
    }
    
    /*override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (self.started) {
            var positive = true
            let dy = self.heli.physicsBody?.velocity.dy
            if Double(dy!) < 0.0 && positive {
                print(dy)
                positive = false
            }
        }*/
        
        
    
    
    /*func heliMove(helicopter: SKSpriteNode) {
        let duration = 5.0
        let posX = size.width - helicopter.size.width/2
        let posY = helicopter.position.y + 200
        
        let actionMove = SKAction.move(to: CGPoint(x: posX, y: posY), duration: TimeInterval(duration))
        let nextActionMove = SKAction.move(to: CGPoint(x: size.width * 0.2, y: posY + 200), duration: duration)
        helicopter.run(SKAction.sequence([actionMove, nextActionMove]))
    }*/
    
    
}
