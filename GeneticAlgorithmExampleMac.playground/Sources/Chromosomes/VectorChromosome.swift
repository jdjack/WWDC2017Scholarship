import Foundation


public class VectorChromosome: Chromosome {
    public typealias T = VectorGene
    public typealias U = VectorChromosome
    
    public var values: [VectorGene]!
    
    public init(values: [VectorGene]) {
        self.values = values
    }
    
    public var description: String {
        return "\(values!)"
    }
    
    
    public static func largestOf(_ chrom1: VectorChromosome, _ chrom2: VectorChromosome) -> VectorChromosome {
        return chrom1.count() > chrom2.count() ? chrom1 : chrom2
    }
    
    public static func smallestOf(_ chrom1: VectorChromosom e, _ chrom2: VectorChromosome) -> VectorChromosome {
        return chrom1.count() > chrom2.count() ? chrom2 : chrom1
    }
    
    public func breedWith(_ chromosome: VectorChromosome, breedMode: BreedMode) -> VectorChromosome {
        
        let largest = VectorChromosome.largestOf(self, chromosome)
        var smallest = VectorChromosome.smallestOf(self, chromosome)
        
        let zipped: [(VectorGene, VectorGene)]
        
        if breedMode == .KeepShortest {
            //Do nothing
        } else {
            smallest = smallest.padToSizeOf(chrom: largest)
        }
        
        zipped = Array(zip(largest.values, smallest.values))
        
        
        
        let newVals = zipped.map { (genePair) -> VectorGene in
            return VectorGene(value: (genePair.0.value + genePair.1.value) / 2)
        }
        
        return VectorChromosome(values: newVals)
    }
    
    
    public func tryToMutate(minVal: Int, maxVal: Int, chance: UInt32) {
        let mutateChance = arc4random_uniform(10)
        
        if mutateChance < chance {
            let valueIndex = arc4random_uniform(UInt32(values.count))
            values.remove(at: Int(valueIndex))
            values.insert(VectorGene.randomValue(minValue: minVal, maxVal: maxVal), at: Int(valueIndex))
        }
    }
    
    public func padToSizeOf(chrom: VectorChromosome) -> VectorChromosome {
        
        var vals:[VectorGene] = self.values
        
        while (vals.count < chrom.count()) {
            vals.append(chrom.values[vals.count])
        }
        
        return VectorChromosome(values: vals)
    }
    
    
    public func count() -> Int {
        return values.count
    }
    
    public func append(_ elem: VectorGene) {
        values.append(elem)
    }
    
}
