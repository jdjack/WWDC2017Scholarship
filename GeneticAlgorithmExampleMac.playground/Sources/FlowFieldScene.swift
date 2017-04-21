import Foundation
import SpriteKit


public class FlowFieldScene: SKScene {
    
    let parentView: MainView
    
    let numOfTestSubjects: Int
    
    let startPoint:CGPoint
    let endPoint:CGPoint
    
    let flowFieldIntensity: CGFloat
    
    let flowField: [[CGFloat]]
    let flowFieldCubeSize: CGSize
    
    var impulses: [CGPoint:CGVector] = [:]
    var testSubjects: [TestSubject] = []
    
    var endPointNode: SKShapeNode!
    
    var readyToStart = false
    
    var mouseDownPoint:CGPoint?
    var mouseUpPoint:CGPoint?
    var outlineBlock: SKSpriteNode!
    
    var lastTime: TimeInterval!
    var timer: TimeInterval = 0
    
    var gen = 1
    var prevSuccessRate = 0
    var bestSoFar = 0
    var percentageChange = 0
    
    public init(size: CGSize, flowField: [[CGFloat]], flowFieldIntensity: CGFloat, parentView: MainView, numTestSubjects: Int, startPoint: CGPoint, endPoint: CGPoint) {
        
        self.numOfTestSubjects = numTestSubjects
        self.parentView = parentView
        
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        self.flowField = flowField
        self.flowFieldIntensity = flowFieldIntensity
        self.flowFieldCubeSize = CGSize(width: size.width / CGFloat(flowField.count), height: size.height / CGFloat(flowField[0].count))
        
        super.init(size: size)
        
        placeFlowField()
        
        placeFinishPoint()
        
        for _ in 0..<numOfTestSubjects {
            self.createTestSubject(pos: startPoint)
        }
        
        
        readyToStart = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placeFinishPoint() {
        endPointNode = SKShapeNode(circleOfRadius: 10)
        endPointNode.strokeColor = SKColor.clear
        endPointNode.fillColor = NSColor(red: 93/255, green: 61/255, blue: 178/255, alpha: 1)
        
        endPointNode.position = endPoint
        
        addChild(endPointNode)
    }
    
    func placeFlowField() {
        
        
        self.physicsWorld.gravity = CGVector.zero
        
        for x in 0..<flowField.count {
            
            for y in 0..<flowField[0].count {
                
                let tile = SKSpriteNode(texture: nil, color: SKColor.clear, size: flowFieldCubeSize)
                
                let flowNode = SKSpriteNode(color: SKColor.lightGray, size: CGSize(width: flowFieldCubeSize.width - 4, height: 2))
                
                let rotation = 2 * π * flowField[x][y]
                let position = CGPoint(x: CGFloat(x) * flowFieldCubeSize.width + flowFieldCubeSize.width / 2, y: CGFloat(y) * flowFieldCubeSize.height + flowFieldCubeSize.height / 2)
                
                
                tile.position = position
                flowNode.zRotation = rotation
                
                let dx = cos(rotation) * flowFieldIntensity
                let dy = sin(rotation) * flowFieldIntensity
                
                impulses[CGPoint(x: x, y: y)] = CGVector(dx: dx, dy: dy)
                
                self.addChild(tile)
                tile.addChild(flowNode)
            }
        }
    }
    
    func createTestSubject(pos: CGPoint) {
        
        var genes: [MovementTypeGene] = []
        
        //Roughly 10 seconds of movement
        for _ in 0..<600 {
            genes.append(MovementTypeGene.randomValue(maxVal: 4))
        }
        
        
        let ts = TestSubject(texture: nil, color: SKColor.black, size: CGSize(width: 4, height: 4), forcesChromosome: MovementTypeChromosome(values: genes))
        ts.position = pos
        
        testSubjects.append(ts)
        addChild(ts)
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !readyToStart {
            return
        }
        
        if lastTime == nil {
            lastTime = currentTime
        } else {
            timer += currentTime - lastTime
            lastTime = currentTime
            
            parentView.updateTimerLabel(timer: timer)
            
            if timer > 10 {
                for ts in testSubjects {
                    //TODO: Set the fitness vals
                    ts.setFitness(ts.position.distanceTo(point: endPoint))
                    ts.removeFromParent()
                }
                
                readyToStart = false
                
                breedNextGeneration()
                startNextGeneration()
                return
            }
        }
        
        for ts in testSubjects {
            
            ts.updatePosition()
            
            ts.updateWithFlowField(impulse: impulses[closestFlowTilePoint(p: ts.position)], targetPosition: endPoint, currentTimer: timer)
            
        }
    }
    
    private func breedNextGeneration() {
        
        
        testSubjects.sort { (ts1, ts2) -> Bool in
            ts1.fitness < ts2.fitness
        }
        
        
        let perfectTSs = testSubjects.filter { (ts) -> Bool in
            ts.fitness < 100
        }
        
        if prevSuccessRate == 0 {
            if perfectTSs.count == 0 {
                percentageChange = 0
            } else {
                percentageChange = 100
            }
        } else {
            percentageChange = ((perfectTSs.count - prevSuccessRate) * 100) / perfectTSs.count
        }
        
        prevSuccessRate = perfectTSs.count
        
        
        
        bestSoFar = prevSuccessRate > bestSoFar ? prevSuccessRate : bestSoFar
        
        let middlePoint = max(perfectTSs.count, (testSubjects.count + 1) / 2)
        
        for _ in middlePoint..<testSubjects.count {
            testSubjects.remove(at: middlePoint)
        }
        
        
        //Lets do the last breed straight away, so we dont have to loop
        
        let ts1 = testSubjects[0]
        let ts2 = testSubjects[middlePoint - 1]
        
        let newTsChrom = ts1.forcesChromosome.breedWith(ts2.forcesChromosome, breedMode: .KeepShortest)
        
        newTsChrom.tryToMutate(minVal: 0, maxVal: 5, chance: 5)
        
        let newTs = TestSubject(texture: nil, color: SKColor.black, size: CGSize(width: 4, height: 4), forcesChromosome: newTsChrom)
        
        testSubjects.append(newTs)
        
        
        for i in 0..<middlePoint - 1 {
            let first = testSubjects[i]
            let second = testSubjects[i + 1]
            
            let breedChrom = first.forcesChromosome.breedWith(second.forcesChromosome, breedMode: .KeepShortest)
            breedChrom.tryToMutate(minVal: 0, maxVal: 5, chance: 5)
            
            let child = TestSubject(texture: nil, color: SKColor.black, size: CGSize(width: 4, height: 4), forcesChromosome: breedChrom)
            
            testSubjects.append(child)
            
            testSubjects[i] = TestSubject(first)
            
        }
        
        testSubjects[middlePoint - 1] = TestSubject(testSubjects[middlePoint - 1])
        
        for _ in numOfTestSubjects..<testSubjects.count {
            testSubjects.remove(at: numOfTestSubjects)
        }
        
    }
    
    
    public override func mouseDown(with event: NSEvent) {
        mouseDownPoint = event.location(in: self)
        mouseUpPoint = mouseDownPoint
        
        let minX = min(mouseDownPoint!.x, mouseUpPoint!.x)
        let minY = min(mouseDownPoint!.y, mouseUpPoint!.y)
        
        let maxX = max(mouseDownPoint!.x, mouseUpPoint!.x)
        let maxY = max(mouseDownPoint!.y, mouseUpPoint!.y)
        
        
        outlineBlock = SKSpriteNode(texture: nil, color: NSColor(white: 0.5, alpha: 0.5), size: CGSize(width: maxX - minX, height: maxY - minY))
        outlineBlock.zPosition = 3
        
        outlineBlock.position = CGPoint(x: minX, y: minY)
        
        addChild(outlineBlock)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        mouseUpPoint = event.location(in: self)
        
        let minX = min(mouseDownPoint!.x, mouseUpPoint!.x)
        let minY = min(mouseDownPoint!.y, mouseUpPoint!.y)
        
        let maxX = max(mouseDownPoint!.x, mouseUpPoint!.x)
        let maxY = max(mouseDownPoint!.y, mouseUpPoint!.y)
        
        
        outlineBlock.size = CGSize(width: maxX - minX, height: maxY - minY)
        outlineBlock.position = CGPoint(x: minX + outlineBlock.size.width / 2, y: minY + outlineBlock.size.height / 2)
    }
    
    public override func mouseUp(with event: NSEvent) {
        mouseUpPoint = event.location(in: self)
        
        let minX = min(mouseDownPoint!.x, mouseUpPoint!.x)
        let minY = min(mouseDownPoint!.y, mouseUpPoint!.y)
        
        let maxX = max(mouseDownPoint!.x, mouseUpPoint!.x)
        let maxY = max(mouseDownPoint!.y, mouseUpPoint!.y)
        
        
        outlineBlock.size = CGSize(width: maxX - minX, height: maxY - minY)
        outlineBlock.position = CGPoint(x: minX + outlineBlock.size.width / 2, y: minY + outlineBlock.size.height / 2)
        
        outlineBlock.color = NSColor(red: 74/255, green: 49/255, blue: 163/255, alpha: 1)
        outlineBlock.physicsBody = SKPhysicsBody(rectangleOf: outlineBlock.size)
        outlineBlock.physicsBody!.isDynamic = false
        outlineBlock.physicsBody!.categoryBitMask = 0x01
        
    }
    
    func startNextGeneration() {
        timer = 0
        gen += 1
        parentView.updateGenLabel(gen: gen)
        parentView.updateSuccessLabel(prevSuccessRate: prevSuccessRate, total: numOfTestSubjects)
        parentView.updateBestSoFarLabel(bsf: bestSoFar)
        parentView.updatePercentageChangeLabel(pc: percentageChange)
        lastTime = nil

        for ts in testSubjects {
            ts.position = startPoint
            addChild(ts)
        }
        
        readyToStart = true
        
    }
    
    private func closestFlowTilePoint(p: CGPoint) -> CGPoint {
        
        let closestY = floor(p.y / flowFieldCubeSize.height)
        let closestX = floor(p.x / flowFieldCubeSize.width)
        
        let point = CGPoint(x: closestX, y: closestY)
        
        return point
    }
}
