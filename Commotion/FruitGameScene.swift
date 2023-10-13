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
    let GAMEOVWR_IMAGENAME:String="Gameover"
    struct PhysicsCategory{
       static let fruit:UInt32=0x00000001// set the category for the collision detect
        static let shuriken:UInt32=0x00000002
        static let none:UInt32=0
    }
   
    
    var gameRunning=true //flag for the running state, using for stop or start
    var isGameover=false// flag for the status that gameover and help to restart
    
    // seting score label
    let scoreLabel=SKLabelNode(fontNamed: "Chalkduster")
    let timeLabel=SKLabelNode(fontNamed: "Helvetica")
    var remainTime=30 // 30s of this game
    var timer:Timer?
    var scoreNow:Int = 0{
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
    
    lazy var playerNode = SKSpriteNode(imageNamed:  SHURIKEN_IMAGENAME)//ninja shuriken(special dart), player controll the shuriken to move to the fruit
    lazy var pauseImageNode=SKSpriteNode(imageNamed: PAUSE_IMAGENAME)
    lazy var gameoverImageNode=SKSpriteNode(imageNamed: GAMEOVWR_IMAGENAME)
    
    var shurikenSpeed:Int=1 // this is default speed . and if player walk than 1k steps it will be 2
    
    
    // the skview is initialed and add the player , set the initial setting into scence
    override func didMove(to view: SKView) {
      startGame()
    }
    
    //start game from 0
    func startGame(){
        physicsWorld.contactDelegate=self
        backgroundColor=SKColor.white
   
        self.addSocre() //add the score to save the date
        self.addPlayer()  // add the player blade on the stage
        self.addTimeLabel() // add the timer to reminder player this game is 30seconds game
        self.run(repeatAction,withKey: ADDFRUIT_KEYNAME)    //when start game directly start the game
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats:true) //for update the game
        NotificationCenter.default.addObserver(self, selector: #selector(scenewillLostFocus(_:)), name: Notification.Name("SceneWillLostFocus"), object: nil) // for receive the segue action
    }
    
    
    // function to update the game time reminder
    @objc func updateTime(){
        if gameRunning && isGameover==false{
            remainTime=remainTime-1
            timeLabel.text="\(remainTime)s"
            if(remainTime==0){ // this is game over function
                gameover() // call the gameover
            }
        }
    }
    
    // react for the segue from the scene
    @objc func scenewillLostFocus(_ notification: Notification){
        if gameRunning==true{
            self.removeAction(forKey: ADDFRUIT_KEYNAME)// stop generate the fruit
            addPauseImage()
            gameRunning=false
        }
    }
    
    func gameover(){
         isGameover=true
         self.removeAction(forKey: ADDFRUIT_KEYNAME)//
         gameRunning=false
        addGameover()
        timer?.invalidate()
        timer=nil
         scoreLabel.fontSize = scoreLabel.fontSize*4
    }
    
    
    // set the timer
    func addTimeLabel(){
        timeLabel.text="\(remainTime)s"
        timeLabel.fontSize=40
        timeLabel.fontColor=SKColor.black
        timeLabel.position=CGPoint(x: frame.midX, y: frame.maxY-frame.height*0.15)
        addChild(timeLabel)
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
        playerNode.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        playerNode.size=CGSize(width: size.width*0.12, height: size.width*0.12)
        playerNode.physicsBody=SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.contactTestBitMask=PhysicsCategory.fruit // notify the listner
        playerNode.physicsBody?.collisionBitMask=PhysicsCategory.none
        playerNode.physicsBody?.categoryBitMask=PhysicsCategory.shuriken
        playerNode.physicsBody?.affectedByGravity=false
        self.addChild(playerNode)
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
        fruitNode.physicsBody?.affectedByGravity=false
        self.addChild(fruitNode)
    }
    
    
    func addGameover(){
        gameoverImageNode.size=CGSize(width: size.width*0.9, height: size.width*0.9)
        gameoverImageNode.position=CGPoint(x: size.width*0.5, y: size.height*0.5)
        addChild(gameoverImageNode)
    }
    
 
    
    // func to play the hit animation and somthing
    func shurikenDidCollideWithFruit(shuriken:SKSpriteNode,fruit:SKSpriteNode){
        print("hit")
        //pending to animation
        scoreNow=scoreNow+1
        fruit.removeFromParent()
    }
    
    
    //contact delegat method
    func didBegin(_ contact: SKPhysicsContact) {
        var secondBody:SKPhysicsBody = contact.bodyB
        var isHit=true
        if contact.bodyA.node == playerNode {
            print("BodyB is Fruit")
            secondBody=contact.bodyB
        }else if contact.bodyB.node==playerNode{
            print("BodyA is Fruit")
            secondBody=contact.bodyA
        }else{
            isHit=false
        }
        
        if isHit{
            if let fruit = secondBody.node as? SKSpriteNode{
                shurikenDidCollideWithFruit(shuriken: self.playerNode, fruit: fruit)
            }
        }
    }
    
    
    // move the player shurikan
    override func update(_ currentTime: TimeInterval) {
        
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
        if gameRunning==true && isGameover==false{    //pause game
            self.removeAction(forKey: ADDFRUIT_KEYNAME)
            addPauseImage()
            gameRunning=false
        }else if gameRunning==false && isGameover==false {   //resume from pasuing status
            self.run(repeatAction, withKey: ADDFRUIT_KEYNAME)
            self.removeChildren(in: [pauseImageNode])
            gameRunning=true
        }else if isGameover==true{    //start from gameover
            remainTime=30
            scoreNow=0
            removeAllChildren()
            gameRunning=true
            isGameover=false
            startGame()
        }
    }
    
    
    // random function for geting the position
    func random()->CGFloat{
        return CGFloat(Float(arc4random())/Float(UInt32.max))
    }
    
    func random(min:CGFloat,max:CGFloat)->CGFloat{
        return random()*(max-min)+min
    }
    
    
}
