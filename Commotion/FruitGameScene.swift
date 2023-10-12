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
    
    //Static properties for the static.
    static let ShurikenImageName="Shuriken"
    static let WatermelonImageName="Watermelon"
    
    
    
    // ninja shuriken, player controll the shuriken to move to the fruit and cut the target to get the socer
    let player = SKSpriteNode(imageNamed:  ShurikenImageName)
    
    
    // the skview isstrating work and add the player into scence
    //set the scence
    //set the player's position
    override func didMove(to view: SKView) {
        backgroundColor=SKColor.white
        player.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(player)
    }
    
    
}
