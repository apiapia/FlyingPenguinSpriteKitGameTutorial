//
//  Playing.swift
//  FlyingPenguin

//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState :GKState {
    unowned let scene:GameScene
    
    init(scene:SKScene){
        self.scene = scene as! GameScene
        super.init()
    }
    //只调用一次
    override func didEnter(from previousState: GKState?) {
        scene.moveAllowed = true // 开始生成;
        scene.spawningCoins()     // 调用spawingCoins生成
        scene.spawningObstcale(TimeInterval(scene.randomDelay()))
        scene.stopWobble()       // 停止上下浮动
        scene.startAnimation()  // 开始拍打翅膀;
        //初始化向上的速度
        scene.applyInitialImpluse()
        
    }
    override func willExit(to nextState: GKState) {
        
    }
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
    }
    // 每FRAME需要调用
    override func update(deltaTime seconds: TimeInterval) {
        // 继续player时时运行
        scene.applyInstantlyMovement(seconds)
    }
}
