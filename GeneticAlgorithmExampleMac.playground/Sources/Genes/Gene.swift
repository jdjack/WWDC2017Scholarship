import Cocoa

public protocol Gene: CustomStringConvertible {
    associatedtype T
    associatedtype U
    
    static func randomValue(maxVal: UInt32) -> U
    static func randomValue(minValue: Int, maxVal: Int) -> U
    
    var value: T! { get set }
}
