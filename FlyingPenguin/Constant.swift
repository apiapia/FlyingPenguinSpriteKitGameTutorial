//
//  Constant.swift
//  FlyingPenguin
//
//  Copyright © 2018 iFiero. All rights reserved.
//
import UIKit
import SpriteKit
import CoreGraphics

// 物理标识;
struct PhysicsCategory {
    
    static let None: UInt32      = 0x1 << 1
    static let Player: UInt32    = 0x1 << 2
    static let Obstacle: UInt32  = 0x1 << 3
    static let Coin:UInt32       = 0x1 << 4
    static let Ground: UInt32    = 0x1 << 5
    static let Floor: UInt32     = 0x1 << 6
    static let PlayerLose:UInt32 = 0x1 << 7
    static let Crown:UInt32      = 0x1 << 8
}
// UI图层位置;
enum Layer:CGFloat {
    case Background
    case Cloud
    case Mountain
    case Tree
    case Obstacle
    case Player
}
