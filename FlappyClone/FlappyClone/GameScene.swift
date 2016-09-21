//
//  GameScene.swift
//  FlappyClone
//
//  Created by Junior Vasquez on 5/21/16.
//  Copyright (c) 2016 Junior Vasquez. All rights reserved.
//

import SpriteKit

struct PhysicsCategory{
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    
    let scoreLabl = SKLabelNode()
    
    var died = Bool()
    var restartBTN = SKSpriteNode()
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    
    }
    
    func createScene(){
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        
        scoreLabl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLabl.text = "\(score)"
        scoreLabl.fontName = "04b_19"
        scoreLabl.fontSize = 60
        scoreLabl.zPosition = 5
        self.addChild(scoreLabl)
        
        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)
        
        Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        Ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.dynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        
        
        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.dynamic = true
        
        Ghost.zPosition = 2
        
        self.addChild(Ghost)

    
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup for your scene here */
   
        createScene()
        
    }
    

    func createBTN(){
        
        
        
        restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSizeMake(200, 100)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        
        restartBTN.runAction(SKAction.scaleTo(1.0, duration: 0.3))
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Ghost{
        
            score += 1
            scoreLabl.text = "\(score)"
            firstBody.node?.removeFromParent()

        }
            
         else if firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Score{
            
            score += 1
            scoreLabl.text = "\(score)"
            secondBody.node?.removeFromParent()
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Ghost{
            
            enumerateChildNodesWithName("wallPair", usingBlock: ({
            (node, error) in
                
                node.speed = 0
                self.removeAllActions()
            
            }))
            if died == false{
                  died = true
                createBTN()
            }
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Ghost{
            
            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                createBTN()
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false{
            
            gameStarted = true
            
            Ghost.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.runBlock({
                () in
                
                self.createWalls()
            })
            
            let delay = SKAction.waitForDuration(1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
            self.runAction(spawnDelayForever)
            
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance - 50, y: 0, duration: NSTimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        
        }
        else {
            
            if died == true{
            
            
            }
            
            else{
            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }
        }
        
        
        
        for touch in touches{
            
            let location = touch.locationInNode(self)
            
            if died == true {
                
                if restartBTN.containsPoint(location){
                
                    restartScene()
                }
                
                }
        
        }
        
        
    }
    
    func createWalls(){
        
        
        let scoreNode = SKSpriteNode(imageNamed: "Coin")
        
        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 )
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        scoreNode.color = SKColor.blueColor()
        
        
        
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        btmWall.physicsBody?.dynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        
        wallPair.runAction(moveAndRemove)

        
        self.addChild(wallPair)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        /* Called before each frame is rendered */
        if gameStarted == true{
            if died == false{
                enumerateChildNodesWithName("background", usingBlock: ({
                        (node, error) in
                    
                        let bg =  node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                
                    if bg.position.x <= -bg.size.width {
                    
                        bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y)
                    
                    }
                
                }))
            }
        }
        
        
    }
}