//  GameScene.swift
//  MazeMaze
//
//  Created by Krystyna Swider on 11/2/17.
//  Copyright © 2017 Krystyna Swider. All rights reserved.
//
import Foundation
import SpriteKit
//import GameplayKit
import CoreMotion

class level2: SKScene, SKPhysicsContactDelegate {
    struct PhysicsCategory {
        static let ninja : UInt32 = 0b1 << 0
        static let dojoDoor : UInt32 = 0b1 << 1
        static let coin : UInt32 = 0b1 << 2
    }
    let manager = CMMotionManager()
    var dojoDoor = SKSpriteNode()
    var ninja = SKSpriteNode()
    var coin = SKSpriteNode()
    var points = Int()
    
    var scoreLabel = SKLabelNode()
    //    let scoreLabelName = "scoreLabel"
    
    override func didMove(to view: SKView) {
        //we'll fix level 2
        //it did something, but not quite what we want
        
        self.physicsWorld.contactDelegate = self
        dojoDoor = self.childNode(withName: "dojoDoor") as! SKSpriteNode
        ninja = self.childNode(withName: "ninja") as! SKSpriteNode
        coin = self.childNode(withName: "coin") as! SKSpriteNode
        scoreLabel = self.childNode(withName:"scoreLabel") as! SKLabelNode
        
        ninja.physicsBody?.categoryBitMask = PhysicsCategory.ninja
        ninja.physicsBody?.collisionBitMask = PhysicsCategory.coin | PhysicsCategory.dojoDoor
        
        coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
        coin.physicsBody?.collisionBitMask = PhysicsCategory.ninja
        
        dojoDoor.physicsBody?.categoryBitMask = PhysicsCategory.dojoDoor
        dojoDoor.physicsBody?.collisionBitMask = PhysicsCategory.ninja
        points = 0
        
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        let myQueue = OperationQueue()
        manager.startAccelerometerUpdates(to: myQueue){
            (data, error) in
            if let myData = data {
                self.physicsWorld.gravity = CGVector(dx: CGFloat((myData.acceleration.x)) * 10, dy: CGFloat((myData.acceleration.y)) * 10)
                //                print("im moving")
            }
            if let err = error {
                print(err)
                self.manager.stopAccelerometerUpdates()
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        print("contact happened")
        
        if bodyA.node?.name == "ninja" && bodyB.node?.name == "dojoDoor" || bodyA.node?.name == "dojoDoor" && bodyB.node?.name == "ninja"{
            print("Think you are a true Ninja?!")
        }
        if bodyA.node?.name == "ninja" && bodyB.node?.name == "coin" || bodyA.node?.name == "coin" && bodyB.node?.name == "ninja"{
            print("You got a point!")
            
            if bodyA.node?.name == "coin" {
                bodyA.node?.removeFromParent()
            } else if bodyB.node?.name == "coin" {
                bodyB.node?.removeFromParent()
            }
            //                coin.removeFromParent()
            
            points += 1
            scoreLabel.text = String(points)
            let userDefault = Foundation.UserDefaults.standard
            userDefault.set(points, forKey: "score")
            print(points)
            
            // count and show points on the scene  - OK
            // make other points dissapear         -
            
        }
        
        func viewWillAppear(_ animated:Bool){
            let userDefault = Foundation.UserDefaults.standard
            let value = userDefault.string(forKey: "score")
            //                scoreLabel.text = value
            if(value == nil){
                scoreLabel.text = "0"
            }else{
                scoreLabel.text = value
            }
        }
    }
    
    
    
}



