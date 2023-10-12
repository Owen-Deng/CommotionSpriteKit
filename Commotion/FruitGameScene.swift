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
     let SHURIKENIMAGENAME:String="Shuriken"
     let WATERMELONIMAGENAME:String="Watermelon"
     let ADDFRUITKEYNAME:String="addFruit"
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
    lazy var player = SKSpriteNode(imageNamed:  SHURIKENIMAGENAME)
    
    
    // the skview is initialed and add the player into scence
    //set the scence
    //set the player's position
    override func didMove(to view: SKView) {
        backgroundColor=SKColor.white
        player.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(player) // add the player
           // pending add the score

        //when start game directly start the game
        self.run(repeatAction,withKey: ADDFRUITKEYNAME)
        
    }
    
    // add score node label into the secene
    func addSocre(){
        
    }
    
    // add the fruit into secene to be the target of the shuriken
    func addFruits(){
        print("add fruit")
        let fruitNode = SKSpriteNode(imageNamed: WATERMELONIMAGENAME)
        fruitNode.size=CGSize(width: size.width*0.1, height: size.height*0.1)
        
        let startY=random()
        // xy the fruit add
        // determing the speed of fruitam
        // action-- moving
    }
    
    
    // generat the postion about the fruit in the random of the whole scene
    func fruitsPosition()->CGPoint{
        var position=CGPoint(x: 0, y: 0)//default place
        let randomX=random()
        
        return position
    }
    
    // touch to pause the game
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameRunning==true{
            self.removeAction(forKey: ADDFRUITKEYNAME)// stop generate the fruit
            gameRunning=false
        }else {
            self.run(repeatAction, withKey: ADDFRUITKEYNAME)
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
