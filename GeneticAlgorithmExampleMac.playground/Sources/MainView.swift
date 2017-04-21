import Cocoa



public class MainView: NSView {
    
    let timerLabel:NSTextField!
    let genLabel:NSTextField!
    let successLabel:NSTextField!
    let bestSoFarLabel:NSTextField!
    let percChangeLabel:NSTextField!
    
    public override var wantsUpdateLayer: Bool {
        return true
    }
    
    override public init(frame frameRect: NSRect) {
        
        genLabel = NSTextField(frame: NSRect(x: frameRect.midX - 200, y: frameRect.size.height - 40 - 20, width: 400, height: 40))
        
        successLabel = NSTextField(frame: NSRect(x: 30, y: frameRect.size.height - 70 - 45, width: 400, height: 30))
        
        bestSoFarLabel = NSTextField(frame: NSRect(x: 30, y: frameRect.size.height - 100 - 45, width: 400, height: 30))
        
        percChangeLabel = NSTextField(frame: NSRect(x: 30, y: frameRect.size.height - 130 - 45, width: 400, height: 30))
        
        timerLabel = NSTextField(frame: NSRect(x: frameRect.size.width - 400 - 30, y: frameRect.size.height - 70 - 45, width: 400, height: 30))
        
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        genLabel.isEditable = false
        genLabel.stringValue = "Generation 1"
        genLabel.font = NSFont(name: "HelveticaNeue-UltraLight", size: 36)
        genLabel.drawsBackground = false
        genLabel.isBezeled = false
        genLabel.textColor = NSColor.white
        genLabel.alignment = NSTextAlignment.center
        
        successLabel.isEditable = false
        successLabel.stringValue = "Previous Success: N/A"
        successLabel.font = NSFont(name: "HelveticaNeue-Light", size: 18)
        successLabel.drawsBackground = false
        successLabel.isBezeled = false
        successLabel.textColor = NSColor.white
        successLabel.alignment = NSTextAlignment.left
        
        bestSoFarLabel.isEditable = false
        bestSoFarLabel.stringValue = "Best So Far: N/A"
        bestSoFarLabel.font = NSFont(name: "HelveticaNeue-Light", size: 18)
        bestSoFarLabel.drawsBackground = false
        bestSoFarLabel.isBezeled = false
        bestSoFarLabel.textColor = NSColor.white
        bestSoFarLabel.alignment = NSTextAlignment.left
        
        percChangeLabel.isEditable = false
        percChangeLabel.stringValue = "Percentage Change: N/A"
        percChangeLabel.font = NSFont(name: "HelveticaNeue-Light", size: 18)
        percChangeLabel.drawsBackground = false
        percChangeLabel.isBezeled = false
        percChangeLabel.textColor = NSColor.white
        percChangeLabel.alignment = NSTextAlignment.left
        
        timerLabel.isEditable = false
        timerLabel.stringValue = "Timer: 0"
        timerLabel.font = NSFont(name: "HelveticaNeue-Light", size: 18)
        timerLabel.drawsBackground = false
        timerLabel.isBezeled = false
        timerLabel.textColor = NSColor.white
        timerLabel.alignment = NSTextAlignment.right
        
        addSubview(timerLabel)
        addSubview(genLabel)
        addSubview(successLabel)
        addSubview(bestSoFarLabel)
        addSubview(percChangeLabel)
        
//        let footer = NSBox(frame: NSRect(x: 0, y: frameRect.size.height - 200, width: frameRect.size.width, height: 20))
//        
//        footer.fillColor = NSColor(red: 74/255, green: 49/255, blue: 163/255, alpha: 1)
//        footer.borderColor = NSColor.clear
//        footer.title = ""
//        footer.boxType = .custom
//        //addSubview(footer)
        
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateLayer() {
        self.layer!.backgroundColor = CGColor(red: 93/255, green: 61/255, blue: 178/255, alpha: 1)
    }
    
    
    public func updateTimerLabel(timer: TimeInterval) {
        timerLabel.stringValue = "Timer: \(Int(timer))"
    }
    
    public func updateGenLabel(gen: Int) {
        genLabel.stringValue = "Generation \(gen)"
    }
    
    public func updateBestSoFarLabel(bsf: Int) {
        bestSoFarLabel.stringValue = "Best So Far: \(bsf)"
    }
    
    
    public func updateSuccessLabel(prevSuccessRate: Int, total: Int) {
        successLabel.stringValue = "Previous Success: \(prevSuccessRate) / \(total)"
    }
    
    public func updatePercentageChangeLabel(pc: Int) {
        percChangeLabel.stringValue = "Percentage Change: \(pc)%"
    }
}
