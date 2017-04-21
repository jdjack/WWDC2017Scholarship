import Cocoa



public class PointChromosome: Chromosome {
    public typealias T = PointGene
    public typealias U = PointChromosome
    
    public var values: [PointGene]!
    
    public init(values: [PointGene]) {
        self.values = values
    }
    
    public var description: String {
        return "\(values!)"
    }
    
    public static func largestOf(_ chrom1: PointChromosome, _ chrom2: PointChromosome) -> PointChromosome {
        return chrom1.count() > chrom2.count() ? chrom1 : chrom2
    }
    
    public static func smallestOf(_ chrom1: PointChromosome, _ chrom2: PointChromosome) -> PointChromosome {
        return chrom1.count() > chrom2.count() ? chrom2 : chrom1
    }
    
    public func breedWith(_ chromosome: PointChromosome, breedMode: BreedMode) -> PointChromosome {

        let largest = PointChromosome.largestOf(self, chromosome)
        var smallest = PointChromosome.smallestOf(self, chromosome)
        
        let zipped: [(PointGene, PointGene)]
        
        if breedMode == .KeepShortest {
            //Do nothing
        } else {
            smallest = smallest.padToSizeOf(chrom: largest)
        }
        
        zipped = Array(zip(largest.values, smallest.values))
        
        
        
        let newVals = zipped.map { (genePair) -> PointGene in
            return PointGene(value: (genePair.0.value + genePair.1.value) / 2)
        }
        
        return PointChromosome(values: newVals)
    }
    
    
    public func tryToMutate(minVal: Int, maxVal: Int, chance: UInt32) {
        let mutateChance = arc4random_uniform(10)
        
        if mutateChance < chance {
            let valueIndex = arc4random_uniform(UInt32(values.count))
            values.remove(at: Int(valueIndex))
            values.insert(PointGene.randomValue(minValue: minVal, maxVal: maxVal), at: Int(valueIndex))
        }
    }
    
    public func padToSizeOf(chrom: PointChromosome) -> PointChromosome {
        
        var vals:[PointGene] = self.values
        
        while (vals.count < chrom.count()) {
            vals.append(chrom.values[vals.count])
        }
        
        return PointChromosome(values: vals)
    }
    
    
    public func count() -> Int {
        return values.count
    }
    
    public func append(_ elem: PointGene) {
        values.append(elem)
    }
    
}
