//
//  FallingState.swift
//  FlyingPenguin
//

//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class FallingState:GKState {
    
    unowned let scene:GameScene
    
    let whackSound   = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let fallingSound = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    
    //  加入果汁 Screen Shake ,调用 Resources->Utils
    override func didEnter(from previousState: GKState?) {
        // Shake
        let worldNode  = scene.childNode(withName: "worldNode")
        let shake = SKAction.screenZoomWithNode(worldNode!, amount: CGPoint(x: 0.0, y: 7.0), oscillations: 10, duration: 1.0)
        worldNode?.run(shake)
        
        // Flash
        let whiteNode = SKSpriteNode(color: SKColor.white, size: scene.size)
        whiteNode.position  = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        whiteNode.zPosition = 7 //位于最顶端
        worldNode?.addChild(whiteNode)
        // 延迟0.01s后删除whiteNode
        whiteNode.run(SKAction.removeFromParentAfterDelay(0.01))
        scene.run(SKAction.sequence([whackSound, SKAction.wait(forDuration: 0.1), fallingSound]))
        // 停止产生;
        scene.stopSpawning()
        // update不允许移动;
        scene.moveAllowed = false
 
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return  stateClass is GameOverState.Type
    }
    override func update(deltaTime seconds: TimeInterval) {
        // 继续player时时运行
        
        scene.applyInstantlyMovement(seconds)
    }
}
