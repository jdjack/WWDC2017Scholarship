import Cocoa

public class PointGene: Gene {
    
    public typealias T = CGPoint
    public typealias U = PointGene
    
    
    public var value: CGPoint!
    
    
    public static func randomValue(maxVal: UInt32) -> PointGene {
        
        arc4random_stir()
        let x = CGFloat(arc4random_uniform(maxVal))
        let y = CGFloat(arc4random_uniform(maxVal))
        
        return PointGene(value: CGPoint(x: x, y: y))
    }
    
    public static func randomValue(minValue: Int, maxVal: Int) -> PointGene {
        
        assert(minValue < maxVal)
        
        arc4random_stir()
        let x = CGFloat(arc4random_uniform(UInt32(maxVal - minValue)))
        let y = CGFloat(arc4random_uniform(UInt32(maxVal - minValue)))
        
        return PointGene(value: CGPoint(x: x + CGFloat(minValue), y: y + CGFloat(minValue)))
    }
    
    public init(value: CGPoint) {
        self.value = value
    }
    
    public var description: String {
        return "\(value!)"
    }
}
