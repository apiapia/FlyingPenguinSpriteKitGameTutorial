//
//  GameOver.swift
//  FlyingPenguin
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState:GKState {
    unowned let scene:GameScene
    // 撞击的声音
    let hitGroundSoundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let crownHitGroundSoundAction = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    // 冒泡
    let popSoundAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let animationDelay = 0.3
    
    let playerLose  = SKSpriteNode(imageNamed: "lose_logo") // 玩家失败的图
    let playerCrown = SKSpriteNode()    // 皇冠
    let loseText = SKSpriteNode(imageNamed: "lose_text")
    let tapToPlay = SKSpriteNode(imageNamed: "tapToPlay")
    private var crownNode = SKSpriteNode()
    
    let groundHeight:CGFloat = 350.0
    private var isHit = false
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    // 游戏结束
    override func didEnter(from previousState: GKState?) {
        scene.run(hitGroundSoundAction)
        scene.stopSpawning()
        scene.moveAllowed = false
        // 调用游戏结束的logo或者标语;
        gameoverLogo()
        // 皇冠加物理体
        crownDroped()
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    // 返回等待播放的State
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == WaitingForTapState.self  // return stateClass is WaitingForTap.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        crownDroppedToTheGround()
    }
    
    func gameoverLogo(){
        
        playerLose.setScale(0.6)
        playerLose.zPosition = 7
        loseText.zPosition = 7
        loseText.setScale(0.7)
        
        tapToPlay.zPosition = 7
        tapToPlay.name = "tapToPlay"
        playerLose.position  = CGPoint(x: scene.frame.midX, y: scene.frame.midY + playerLose.size.height)
        loseText.position  = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        tapToPlay.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY - loseText.size.height - 10)
        
        let worldNode  = scene.childNode(withName: "worldNode")
        worldNode?.addChild(playerLose)
        worldNode?.addChild(loseText)
        worldNode?.addChild(tapToPlay)
        worldNode?.addChild(playerCrown)
        
        let pops = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            popSoundAction,
            SKAction.wait(forDuration: animationDelay),
            popSoundAction,
            SKAction.wait(forDuration: animationDelay),
            popSoundAction,
            ])
        worldNode?.run(pops)
        
        let scaleOut = SKAction.scale(by: 0.9, duration: TimeInterval(0.75))
        scaleOut.timingMode = .easeInEaseOut
        let scaleIn = scaleOut.reversed()
        scaleIn.timingMode  = .easeInEaseOut
        let sequence = SKAction.sequence([scaleOut,scaleIn])
        let repeatForever = SKAction.repeatForever(sequence)
        tapToPlay.run(repeatForever)
    }
    
    //皇冠掉落
    func crownDroped(){
        crownNode =  scene.createCrownSprite() // 创建皇冠精灵
        crownNode.position = CGPoint(x: playerLose.position.x + 80, y: playerLose.position.y + playerLose.size.height / 2 + 25)
        scene.addChild(crownNode)
        
        crownNode.physicsBody?.categoryBitMask = PhysicsCategory.Crown
        crownNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ground
        crownNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        crownNode.physicsBody?.affectedByGravity = true
        crownNode.physicsBody?.isDynamic = true
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        scene.run(SKAction.sequence([
            waitAction,
            SKAction.run {
                self.crownNode.run(SKAction.rotate(byAngle: CGFloat(-15).degreesToRadians(), duration: TimeInterval(0.05)))
                self.crownNode.run(SKAction.move(by: CGVector(dx: 18, dy: 0), duration: TimeInterval(0.3)))
            },
            SKAction.run { [weak self] in
                self?.scene.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            }]))
    }
    
    //update 实时更新皇冠的位置
    
    func crownDroppedToTheGround(){ 
        if  crownNode.position.y  <   groundHeight   {
            crownNode.run(crownHitGroundSoundAction)
            crownNode.physicsBody?.affectedByGravity = false
            crownNode.physicsBody?.isDynamic = false
            crownNode.physicsBody?.categoryBitMask = PhysicsCategory.None
            crownNode.position.y = groundHeight
           
        }
    }
}
