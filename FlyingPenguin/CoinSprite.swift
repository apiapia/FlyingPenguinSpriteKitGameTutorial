//
//  CoinNode.swift
//  FlyingPenguin
//
//  Copyright © 2018 iFiero. All rights reserved.

/* 建立精灵:
 *
 * 方法一：Entity+Component
 * 方法二：新建class 方便代码二次复用;
 * 方法三：extension GameScene  func createCoinSprite() -> SKSpriteNode {};
 *
 * (此处为方法二)
 */

import SpriteKit

public class CoinSprite:SKSpriteNode {
    
    public static func sharedInstance() -> CoinSprite {
        
        let coinNode = CoinSprite(imageNamed: "coin01")
        coinNode.anchorPoint = CGPoint(x: 0, y: 0.5)
        coinNode.name = "coin"
        coinNode.physicsBody = SKPhysicsBody(circleOfRadius: coinNode.size.width / 2)
        coinNode.physicsBody?.affectedByGravity = false  //不受重力影响
        coinNode.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        coinNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        coinNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        coinNode.zPosition = 6  // 地板的上方
        
        // frame
        var coinTextures = [SKTexture]()
        coinTextures.append(SKTexture(imageNamed: "coin01"))
        coinTextures.append(SKTexture(imageNamed: "coin02"))
        let coinAction = SKAction.animate(with: coinTextures, timePerFrame: 0.2)
        let repeatAction    = SKAction.repeatForever(coinAction)
        coinNode.run(repeatAction)
        
        return coinNode
    }
    
    
}
