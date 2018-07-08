/* 注：此文件中的代码为iFIERO所引用,即原创版权非iFIERO所持有. Copyright(c) Razeware LLC */

import SpriteKit

public func SKColorWithRGB(_ r: Int, g: Int, b: Int) -> SKColor {
  return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

public func SKColorWithRGBA(_ r: Int, g: Int, b: Int, a: Int) -> SKColor {
  return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
}
