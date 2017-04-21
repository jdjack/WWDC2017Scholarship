import Cocoa
import SpriteKit


public class TestSubject: SKSpriteNode {
    
    let angleChange = π / 50
    
    public var fitness:CGFloat!
    
    let lightBoost: CGFloat = 2
    let medBoost: CGFloat = 4
    let hardBoost: CGFloat = 7
    
    
    let forcesChromosome: MovementTypeChromosome
    var forces: Queue<MovementTypeGene>
    
    //Clone Initialiser
    public init(_ ts: TestSubject) {
        self.forcesChromosome = ts.forcesChromosome
        forces = Queue<MovementTypeGene>(forcesChromosome.values)
        
        super.init(texture: ts.texture, color: ts.color, size: ts.size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: ts.size)
        self.physicsBody!.collisionBitMask = 0x01
        self.physicsBody!.categoryBitMask = 0
        self.physicsBody!.contactTestBitMask = 0
    }
    
    public init(texture: SKTexture?, color: NSColor, size: CGSize, forcesChromosome: MovementTypeChromosome) {
        
        self.forcesChromosome = forcesChromosome
        forces = Queue<MovementTypeGene>(forcesChromosome.values)
        
        
        super.init(texture: texture, color: color, size: size)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.collisionBitMask = 0x01
        self.physicsBody!.categoryBitMask = 0
        self.physicsBody!.contactTestBitMask = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updatePosition() {
        //TODO: Remove this:
        
        if self.position.x < 0 {
            self.position.x = self.scene!.frame.size.width
        }
        
        if self.position.x > self.scene!.frame.size.width {
            self.position.x = 0
        }
        
        if self.position.y < 0 {
            self.position.y = 0
            self.physicsBody!.velocity.dy = -self.physicsBody!.velocity.dy
        }
        
        if self.position.y > self.scene!.frame.size.height {
            self.position.y = self.scene!.frame.size.height
            self.physicsBody!.velocity.dy = -self.physicsBody!.velocity.dy
        }
    }
    
    public func setFitness(_ f:CGFloat) {
        if self.fitness == nil {
            self.fitness = f + 100
        }
    }
    
    //Returns false when it is out of moves
    public func updateWithFlowField(impulse: CGVector?, targetPosition: CGPoint, currentTimer: TimeInterval) {
        
        if self.position.distanceTo(point: targetPosition) <= 10 {
            fitness = 100 * CGFloat(currentTimer / 10)
            self.physicsBody!.velocity = CGVector.zero
            return
        }
        
        //Apply the next move
        if let nextMove = forces.pop() {
            switch nextMove.value! {
            case .TurnRight:
                zRotation -= angleChange
                break
            case .TurnLeft:
                zRotation += angleChange
                break
            case .LightBoost:
                self.physicsBody!.applyForce(CGVector.vectorWithForceAndAngle(force: lightBoost, angle: zRotation))
                break
            case .MedBoost:
                self.physicsBody!.applyForce(CGVector.vectorWithForceAndAngle(force: medBoost, angle: zRotation))
                break
            case .HardBoost:
                self.physicsBody!.applyForce(CGVector.vectorWithForceAndAngle(force: hardBoost, angle: zRotation))
                break
            }
        } else {
            self.physicsBody!.velocity = CGVector.zero
            return
        }
        
        //Apply the flow field force
        if impulse != nil {
            self.physicsBody!.applyForce(impulse!)
        }
        
        if self.physicsBody!.velocity.speed() > 150 {
            self.physicsBody!.velocity.reduceToSpeed(newSpeed: 150)
        }
    }
    
    
}
