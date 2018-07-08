//
//  SpriteComponent.swift
//  FlyingPenguin
//
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

// node可被重复使用;
class SpriteComponent :GKComponent {
    let node:SKSpriteNode
    init(entity:GKEntity,texture:SKTexture,size:CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        node.entity = entity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
