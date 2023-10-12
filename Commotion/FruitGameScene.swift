//
//  FruitGameScene.swift
//  Commotion
//
//  Created by RongWei Ji on 10/11/23.
//  Copyright © 2023 Eric Larson. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class FruitGameScene:SKScene, SKPhysicsContactDelegate {
    
    
    // MARK: Properties
    //Static properties for the static.
    let SHURIKEN_IMAGENAME:String="Shuriken"
    let WATERMELON_IMAGENAME:String="Watermelon"
    let ADDFRUIT_KEYNAME:String="addFruit"
    let FRUIT_CATEGORY:UInt32=0x00000001
    var gameRunning=true
    
    
    // pending score label
    var scroeNow:Int = 0{
        willSet(newValue){
            DispatchQueue.main.async {
                //update the lable in scence
            }
        }
    }
    
    lazy var  addFruitsAction=SKAction.run {
        self.addFruits()
    }
    lazy var  repeatAction=SKAction.repeatForever(SKAction.sequence([SKAction.run {
        self.addFruits()
    },SKAction.wait(forDuration: 1.5)]))
    var nodeTimer:Timer?
    
    
    
    // ninja shuriken(special dart), player controll the shuriken to move to the fruit and cut the target to get the socer
    lazy var player = SKSpriteNode(imageNamed:  SHURIKEN_IMAGENAME)
    
    
    // the skview is initialed and add the player into scence
    //set the scence
    //set the player's position
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate=self
        backgroundColor=SKColor.white
        player.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(player) // add the player
           // pending add the score

        //when start game directly start the game
        self.run(repeatAction,withKey: ADDFRUIT_KEYNAME)
        
    }
    
    // add score node label into the secene
    func addSocre(){
        
    }
    
    // add the fruit into secene to be the target of the shuriken
    // this version is about the static position that use blade to cut the fruit
    func addFruits(){
        print("add fruit")
        let fruitNode = SKSpriteNode(imageNamed: WATERMELON_IMAGENAME)
        fruitNode.size=CGSize(width: size.width*0.1, height: size.height*0.1)
        // position for fruit is random and in the whole
        fruitNode.position=randomFruitsPosition()
        fruitNode.physicsBody?.contactTestBitMask=FRUIT_CATEGORY
        fruitNode.physicsBody?.collisionBitMask=FRUIT_CATEGORY
        fruitNode.physicsBody?.categoryBitMask=FRUIT_CATEGORY
        self.addChild(fruitNode)
    }
    
    
    // generat the postion about the fruit in the random of the whole scene
    func randomFruitsPosition()->CGPoint{
        let randomX=random( min: CGFloat(0.1), max: CGFloat(0.9) )
        let randomY=random(min: CGFloat(0.1), max: CGFloat(0.9) )
        return CGPoint(x: randomX, y: randomY)
    }
    
    // touch to pause the game
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameRunning==true{
            self.removeAction(forKey: ADDFRUIT_KEYNAME)// stop generate the fruit
            gameRunning=false
        }else {
            self.run(repeatAction, withKey: ADDFRUIT_KEYNAME)
            gameRunning=true
        }
    }
    
    
    
    
    // random funcion
    func random()->CGFloat{
        return CGFloat(Float(arc4random())/Float(Int.max))
    }
    
    func random(min:CGFloat,max:CGFloat)->CGFloat{
        return random()*(max-min)+min
    }
    
    
    // conllision detetion
    
}
