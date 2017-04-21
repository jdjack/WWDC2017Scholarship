import Foundation


public class MovementTypeChromosome: Chromosome {
    public typealias T = MovementTypeGene
    public typealias U = MovementTypeChromosome
    
    public var values: [MovementTypeGene]!
    
    public init(values: [MovementTypeGene]) {
        self.values = values
    }
    
    public var description: String {
        return "\(values!)"
    }
    
    public static func largestOf(_ chrom1: MovementTypeChromosome, _ chrom2: MovementTypeChromosome) -> MovementTypeChromosome {
        return chrom1.count() > chrom2.count() ? chrom1 : chrom2
    }
    
    public static func smallestOf(_ chrom1: MovementTypeChromosome, _ chrom2: MovementTypeChromosome) -> MovementTypeChromosome {
        return chrom1.count() > chrom2.count() ? chrom2 : chrom1
    }
    
    public func breedWith(_ chromosome: MovementTypeChromosome, breedMode: BreedMode) -> MovementTypeChromosome {
        
        let largest = MovementTypeChromosome.largestOf(self, chromosome)
        var smallest = MovementTypeChromosome.smallestOf(self, chromosome)
        
        let zipped: [(MovementTypeGene, MovementTypeGene)]
        
        if breedMode == .KeepShortest {
            //Do nothing
        } else {
            smallest = smallest.padToSizeOf(chrom: largest)
        }
        
        zipped = Array(zip(largest.values, smallest.values))
        
        
        
        let newVals = zipped.map { (genePair) -> MovementTypeGene in
            
            let deciderVal = arc4random_uniform(2)
            
            if deciderVal == 0 {
                return MovementTypeGene(value: genePair.0.value)
            } else {
                return MovementTypeGene(value: genePair.1.value)
            }
        }
        
        return MovementTypeChromosome(values: newVals)
    }
    
    
    public func tryToMutate(minVal: Int, maxVal: Int, chance: UInt32) {
        let mutateChance = arc4random_uniform(100)
        
        if mutateChance < chance {
            //Replace 5% of the values, 5% of the time
            for _ in 0..<values.count / 20 {
                let valueIndex = arc4random_uniform(UInt32(values.count))
                values.remove(at: Int(valueIndex))
                values.insert(MovementTypeGene.randomValue(minValue: minVal, maxVal: maxVal), at: Int(valueIndex))
            }
        }
    }
    
    public func padToSizeOf(chrom: MovementTypeChromosome) -> MovementTypeChromosome {
        
        var vals:[MovementTypeGene] = self.values
        
        while (vals.count < chrom.count()) {
            vals.append(chrom.values[vals.count])
        }
        
        return MovementTypeChromosome(values: vals)
    }
    
    
    public func count() -> Int {
        return values.count
    }
    
    public func append(_ elem: MovementTypeGene) {
        values.append(elem)
    }
    
}
