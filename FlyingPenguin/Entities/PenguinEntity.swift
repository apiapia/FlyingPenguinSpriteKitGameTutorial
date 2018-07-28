//
//  PenguinEntity.swift
//  FlyingPenguin
//
//  Created by Chen on 2018/7/28.
//  Copyright © 2018 iFiero. All rights reserved.
//

import SpriteKit
import GameplayKit

class PenguinEntity:GKEntity {
    
    var spriteComponent:SpriteComponent! // 属性 大小 texture
    var moveComponent:MoveComponent!     // 移动组件功能;
    var animationComponent:AnimationComponent! //拍打翅膀的组件;
    
    init(imageName:String) {
        super.init()
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        // 加入上下飞动的组件
        moveComponent = MoveComponent(entity: self)
        addComponent(moveComponent)
        
        // 加入拍打翅膀的动画
        let textureAltas = SKTextureAtlas(named: "penguin")
        var textures = [SKTexture]()
        for i in 1...textureAltas.textureNames.count {
            let imageName = "penguin0\(i)"
            textures.append(SKTexture(imageNamed: imageName))
        }
        animationComponent = AnimationComponent(entity: self, textures: textures)
        addComponent(animationComponent)

    }
     // Add Physics
    func addPhysics(){
        let spriteNode = spriteComponent.node
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.frame.size)
        spriteNode.physicsBody?.categoryBitMask  = PhysicsCategory.Player
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Coin | PhysicsCategory.Obstacle | PhysicsCategory.Floor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
