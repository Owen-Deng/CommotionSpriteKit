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
    static let ShurikenImageName="Shuriken"
    static let WatermelonImageName="Watermelon"
    // pending score label
    var scroeNow:Int = 0{
        willSet(newValue){
            DispatchQueue.main.async {
                //update the lable in scence
            }
        }
    }
    
    
    
    // ninja shuriken(special dart), player controll the shuriken to move to the fruit and cut the target to get the socer
    let player = SKSpriteNode(imageNamed:  ShurikenImageName)
    
    
    // the skview is initialed and add the player into scence
    //set the scence
    //set the player's position
    override func didMove(to view: SKView) {
        backgroundColor=SKColor.white
        player.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(player) // add the player
            //pending add fruit
           // pending add the score
        // pending for the update repeatly
    }
    
    // add score node label into the secene
    func addSocre(){
        
    }
    
    // add the fruit into secene to be the target of the shuriken
    func addFruits(){
        // xy the fruit add
        // determing the speed of fruit
        // action-- moving
    }
    
    // touch to pause the game
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //pause funciont
    }
    
    
    
    // random funciont peding
    
    
    
    // cpllision detetion
    
}
