//
//  AnimationComponent.swift
//  FlyingPenguin
//
//  Created by Chen on 2018/7/28.
//  Copyright © 2018 iFiero. All rights reserved.
//

import GameplayKit
import SpriteKit

class AnimationComponent:GKComponent {
    let textures:[SKTexture]
    let spriteComponent: SpriteComponent
    
    init(entity:GKEntity,textures:[SKTexture]) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        self.textures = textures
        super.init()
    }
    // 翅膀拍动
    func startAnimation(){
        let flyAction = SKAction.animate(with: textures, timePerFrame: TimeInterval(0.02))
        let repeatAction = SKAction.repeatForever(flyAction)
        spriteComponent.node.run(repeatAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
