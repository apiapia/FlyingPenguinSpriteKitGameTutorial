//
//  MoveComponent.swift
//  FlyingPenguin
//
//  Created by Andrew Chen
//  Copyright © 2018 iFiero. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveComponent:GKComponent {
    
    /// The node on which animations should be run for this animation component.
    let spriteComponent: SpriteComponent  // 引入SpriteComponent 就不用每次都新建在SpriteComponent的属性了
    
    init(entity:GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 组件 上下飞动;
    func startWobble(){
        let moveUp   = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp,moveDown])
        let repeatWobble = SKAction.repeatForever(sequence)
        spriteComponent.node.run(repeatWobble, withKey: "Wobble")
    }
    
}
