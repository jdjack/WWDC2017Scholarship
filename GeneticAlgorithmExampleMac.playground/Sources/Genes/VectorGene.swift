import Cocoa

public class VectorGene: Gene {
    
    public typealias T = CGVector
    public typealias U = VectorGene
    
    
    public var value: CGVector!
    
    
    public static func randomValue(maxVal: UInt32) -> VectorGene {
        
        arc4random_stir()
        let x = CGFloat(arc4random_uniform(maxVal))
        let y = CGFloat(arc4random_uniform(maxVal))
        
        return VectorGene(value: CGVector(dx: x, dy: y))
    }
    
    public static func randomValue(minValue: Int, maxVal: Int) -> VectorGene {
        
        assert(minValue < maxVal)
        
        arc4random_stir()
        let x = CGFloat(arc4random_uniform(UInt32(maxVal - minValue)))
        let y = CGFloat(arc4random_uniform(UInt32(maxVal - minValue)))
        
        return VectorGene(value: CGVector(dx: x + CGFloat(minValue), dy: y + CGFloat(minValue)))
    }
    
    public init(value: CGVector) {
        self.value = value
    }
    
    public var description: String {
        return "\(value!)"
    }
}
