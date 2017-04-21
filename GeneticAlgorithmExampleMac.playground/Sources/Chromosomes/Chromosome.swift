import Cocoa


public protocol Chromosome: CustomStringConvertible {
    associatedtype T
    associatedtype U
    
    var values: [T]! { get set }
    
    func breedWith(_ chromosome: U, breedMode: BreedMode) -> U
    
    func count() -> Int
    
    func append(_ elem:T)
    
    func tryToMutate(minVal: Int, maxVal: Int, chance: UInt32)
    
    static func largestOf(_ chrom1: U, _ chrom2: U) -> U
    static func smallestOf(_ chrom1: U, _ chrom2: U) -> U
    
    func padToSizeOf(chrom: U) -> U
}
