//
//  ObstacleEntity.swift
//  FlyingPenguin.
//  Copyright © 2018 iFiero. All rights reserved.
//
/* 建立精灵:
 *
 * 方法一：Entity+Component
 * 方法二：新建class 方便代码二次复用;
 * 方法三：extension GameScene  func createCoinSprite() -> SKSpriteNode {};
 *
 * (此处为方法一)
 */
/*
 * Entities:   An entity is a representation of an object in your game.
 * Components: A component contains the logic that performs a specific job on one entity, such as modifying its appearance or shooting a rocket. You make small components for each type of action your entities can do. For example, you might make a movement component, a health component, a melee attack component, and so on.
 * One of the best benefits of this system is that you can reuse components on as many entities as you want,
    allowing you to keep your code clean and organized.
 * Entity:一个entity就是一个对象;
 * Component: (1)移动、(2)射击、(3)跳跃、(4)色彩等不同组件功能;
 * 比如：Enity_A包含有(1)(2),Entity_B包含有(2)(3)组件功能,entity就是来管理不同的组件的管理器;
 */


import SpriteKit
import GameplayKit

class ObstacleEntity:GKEntity {
    var spriteComponent:SpriteComponent! // 精灵组件 
    
    init(imageName:String) {
        super.init()
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
