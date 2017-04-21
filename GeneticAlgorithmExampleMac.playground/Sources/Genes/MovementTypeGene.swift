import Cocoa

public class MovementTypeGene: Gene {
    
    public typealias T = MovementType
    public typealias U = MovementTypeGene
    
    
    public var value: MovementType!
    
    
    public static func randomValue(maxVal: UInt32) -> MovementTypeGene {
        
        assert(maxVal < 5, "MovementTypeGene Error: Max value must be below 5")
        
        let val = MovementType(rawValue: Int(arc4random_uniform(maxVal)))!
        
        return MovementTypeGene(value: val)
    }
    
    public static func randomValue(minValue: Int, maxVal: Int) -> MovementTypeGene {
        
        assert(minValue < maxVal)
        assert(maxVal < 5, "MovementTypeGene Error: Max value must be below 5")
        assert(maxVal >= 0, "MovementTypeGene Error: Min value must be below 0")
        
        arc4random_stir()
        
        let val = MovementType(rawValue: Int(arc4random_uniform(UInt32(maxVal - minValue))))!
        
        return MovementTypeGene(value: val)
    }
    
    public init(value: MovementType) {
        self.value = value
    }
    
    public var description: String {
        return "\(value!)"
    }
}
