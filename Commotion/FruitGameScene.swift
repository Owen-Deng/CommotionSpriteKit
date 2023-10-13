//
//  FruitGameScene.swift
//  Commotion
//
//  Created by RongWei Ji on 10/11/23.
//  Copyright © 2023 Rongwei Ji. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class FruitGameScene:SKScene, SKPhysicsContactDelegate {
    
    
    //Static properties for the static.
    let SHURIKEN_IMAGENAME:String="Shuriken"
    let WATERMELON_IMAGENAME:String="Watermelon"
    let ADDFRUIT_KEYNAME:String="addFruit"
    let PAUSE_IMAGENAME:String="Pause"
    struct PhysicsCategory{
       static let fruit:UInt32=0x00000001// set the category for the collision detect
        static let shuriken:UInt32=0x00000002
        static let none:UInt32=0
    }
   
    
    var gameRunning=true //flag for the running state, using for stop or start
    
    // seting score label
    let scoreLabel=SKLabelNode(fontNamed: "Chalkduster")
    var scroeNow:Int = 0{
        willSet(newValue){
            DispatchQueue.main.async {
                self.scoreLabel.text="Score: \(newValue)"
            }
        }
    }
    
    // this is repeatAction for adding fruit and
    lazy var  repeatAction=SKAction.repeatForever(SKAction.sequence([SKAction.run {
        self.addFruits()
    },SKAction.wait(forDuration: 2)]))
    var nodeTimer:Timer?
    
    
    lazy var player = SKSpriteNode(imageNamed:  SHURIKEN_IMAGENAME)//ninja shuriken(special dart), player controll the shuriken to move to the fruit
    lazy var pauseImageNode=SKSpriteNode(imageNamed: PAUSE_IMAGENAME)
    
    
    
    // the skview is initialed and add the player , set the initial setting into scence
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate=self
        backgroundColor=SKColor.white
   
        self.addSocre() //add the score to save the date
        self.addPlayer()  // add the player blade on the stage
        self.run(repeatAction,withKey: ADDFRUIT_KEYNAME)    //when start game directly start the game
        
    }
    
    // add score node label into the secene
    func addSocre(){
        scoreLabel.text="Score:0"
        scoreLabel.fontSize=20
        scoreLabel.fontColor=SKColor.red
        scoreLabel.position=CGPoint(x: frame.midX, y: frame.minY+frame.height*0.05)
        addChild(scoreLabel)
    }
    
    
    // set the player
    func addPlayer(){
        player.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        player.size=CGSize(width: size.width*0.12, height: size.width*0.12)
        player.physicsBody=SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.contactTestBitMask=PhysicsCategory.fruit // notify the listner
        player.physicsBody?.collisionBitMask=PhysicsCategory.none
        player.physicsBody?.categoryBitMask=PhysicsCategory.shuriken
        self.addChild(player)
    }
    
    
    // set the Pause image
    func addPauseImage(){
        pauseImageNode.size=CGSize(width: size.width*0.3, height: size.width*0.3)
        pauseImageNode.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        self.addChild(pauseImageNode)
    }
    
    // add the fruit into secene to be the target of the shuriken
    // this version is about the static position that use blade to cut the fruit
    func addFruits(){
        let fruitNode = SKSpriteNode(imageNamed: WATERMELON_IMAGENAME)
        fruitNode.size=CGSize(width: size.width*0.1, height: size.width*0.1)
        // position for fruit is random and in the whole
        fruitNode.physicsBody=SKPhysicsBody(rectangleOf: fruitNode.size)
        fruitNode.position=randomFruitsPosition()
        fruitNode.physicsBody?.contactTestBitMask=PhysicsCategory.shuriken //notify the listener
        fruitNode.physicsBody?.collisionBitMask=PhysicsCategory.none
        fruitNode.physicsBody?.categoryBitMask=PhysicsCategory.fruit
        print(fruitNode.position)
        self.addChild(fruitNode)
    }
    
    // func to play the hit animation and somthing
    func shurikenDidCollideWithFruit(shuriken:SKSpriteNode,fruit:SKSpriteNode){
        print("hit")
        //pending to animation
        fruit.removeFromParent()
    }
    
    
    //contact delegat method
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        if contact.bodyA.node == player {
            firstBody=contact.bodyA
            secondBody=contact.bodyB
        }else{
            firstBody=contact.bodyB
            secondBody=contact.bodyA
        }
        
        
        
        
    }
    
    
    //pending move of shuriken
    func moveShuriken(){
        
    }
    
    
    
    
    // generat the postion about the fruit in the random of the whole scene
    func randomFruitsPosition()->CGPoint{
        let randomX=random(min: CGFloat(0.1), max: CGFloat(0.9))
        let randomY=random(min: CGFloat(0.1), max: CGFloat(0.9))
        return CGPoint(x: size.width*randomX, y: size.height*randomY)
    }
    
    // touch to pause the game and restart
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameRunning==true{
            self.removeAction(forKey: ADDFRUIT_KEYNAME)// stop generate the fruit
            addPauseImage()
            gameRunning=false
        }else {
            self.run(repeatAction, withKey: ADDFRUIT_KEYNAME)
            self.removeChildren(in: [pauseImageNode])
            gameRunning=true
        }
    }
    
    
    // random function for geting the position
    func random()->CGFloat{
        return CGFloat(Float(arc4random())/Float(UInt32.max))
    }
    
    func random(min:CGFloat,max:CGFloat)->CGFloat{
        return random()*(max-min)+min
    }
    
    
    // conllision detetion
    
}
