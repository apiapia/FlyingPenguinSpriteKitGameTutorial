/* 注：此文件中的代码为iFIERO所引用,即原创版权非iFIERO所持有.Copyright(c)Razeware LLC */

import CoreGraphics

public extension Int {
  /**
   * Ensures that the integer value stays with the specified range.
   */
  public func clamped(_ range: Range<Int>) -> Int {
    return (self < range.lowerBound) ? range.lowerBound : ((self >= range.upperBound) ? range.upperBound - 1: self)
  }

  public func clamped(_ range: ClosedRange<Int>) -> Int {
    return (self < range.lowerBound) ? range.lowerBound : ((self > range.upperBound) ? range.upperBound: self)
  }

  /**
   * Ensures that the integer value stays with the specified range.
   */
  public mutating func clamp(_ range: Range<Int>) -> Int {
    self = clamped(range)
    return self
  }

  public mutating func clamp(_ range: ClosedRange<Int>) -> Int {
    self = clamped(range)
    return self
  }

  /**
   * Ensures that the integer value stays between the given values, inclusive.
   */
  public func clamped(_ v1: Int, _ v2: Int) -> Int {
    let min = v1 < v2 ? v1 : v2
    let max = v1 > v2 ? v1 : v2
    return self < min ? min : (self > max ? max : self)
  }

  /**
   * Ensures that the integer value stays between the given values, inclusive.
   */
  public mutating func clamp(_ v1: Int, _ v2: Int) -> Int {
    self = clamped(v1, v2)
    return self
  }

  /**
   * Returns a random integer in the specified range.
   */
  public static func random(_ range: Range<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound - 1))) + range.lowerBound
  }

  public static func random(_ range: ClosedRange<Int>) -> Int {
    return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
  }

  /**
   * Returns a random integer between 0 and n-1.
   */
  public static func random(_ n: Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
  }

  /**
   * Returns a random integer in the range min...max, inclusive.
   */
  public static func random(_ min: Int, max: Int) -> Int {
    assert(min < max)
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
  }
}
