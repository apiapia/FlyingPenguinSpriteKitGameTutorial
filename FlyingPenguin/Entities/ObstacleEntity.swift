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


import SpriteKit
import GameplayKit

class ObstacleEntity:GKEntity {
    var spriteComponent:SpriteComponent!
    
    init(imageName:String) {
        super.init()
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        // Entity 物理体 设置 node
        /*
        let node = spriteComponent.node
        node.zPosition = 2 // 位于树的下层
        node.anchorPoint = CGPoint(x: 0.5, y: 0)  // x轴为正中心，旋转后才会位于正顶端; y=0 0.5为正中心;
        node.size.height = 600 //为何调整为高度600：size.height=>1536 - 600 - 600 余236为间隙，让企鹅通过;
        // 障碍物
        node.physicsBody = SKPhysicsBody(rectangleOf: (node.texture?.size())!, center: CGPoint(x: 0.5, y: 0.5))// PhysicsBody
        node.physicsBody?.categoryBitMask    = PhysicsCategory.Obstacle
        node.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        node.physicsBody?.collisionBitMask   = PhysicsCategory.None
        */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
