//
//  WaitingForTap.swift
//  FlyingPenguin
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTapState:GKState {
    
    // unowned 防止循环引用
    unowned let scene:GameScene
    var playButtonNode:SKSpriteNode!
    // 初始化
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    //MARK:- didEnter一进入就执行 类似 GameScene 的 didMove(:) 但获得点击事件touchesBegan是在GameScene中进行判断;
    override func didEnter(from previousState: GKState?) {
        
       scene.moveAllowed = false /// 初始进入WaitState人物+场景是不可以运动的;
       initPlayButton()
        
    }
    
    override func willExit(to nextState: GKState) {
        
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    func initPlayButton(){
        /// 取得playButton节点
        playButtonNode = scene.childNode(withName: "worldNode")?.childNode(withName: "playButton") as! SKSpriteNode
        playButtonNode.setScale(CGFloat(0.7))
        /// 播放按钮的动画;
        let scaleOut = SKAction.scale(by: 0.9, duration: TimeInterval(0.75))
        scaleOut.timingMode = .easeInEaseOut
        let scaleIn = scaleOut.reversed()
        scaleIn.timingMode  = .easeInEaseOut
        /// 播放顺序
        let sequence = SKAction.sequence([scaleOut,scaleIn])
        let repeatForever = SKAction.repeatForever(sequence)
        /// 执行Action
        playButtonNode.run(repeatForever)
        
    }
    
}

