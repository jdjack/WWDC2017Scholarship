import Cocoa
import SpriteKit


let π = CGFloat(M_PI)


public extension SKColor {
    class func colorWithRGB(r:CGFloat, g:CGFloat, b:CGFloat) -> SKColor {
        return SKColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    class func colorWithRGB(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> SKColor {
        return SKColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}

public extension CGPoint {
    
    //Can add points
    static public func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    //Can sub points
    static public func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    //Can add points and sizes (x + width) (y + height)
    static public func + (left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x + right.width, y: left.y + right.height)
    }
    
    //Can sub points and sizes (x - width) (y - height)
    static public func - (left: CGPoint, right: CGSize) -> CGPoint {
        return CGPoint(x: left.x - right.width, y: left.y - right.height)
    }
    
    //Scalar Multiplication
    static public func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    //Scalar Division
    static public func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    static public func meanX(points:[CGPoint]) -> CGFloat {
        
        var sum:CGFloat = 0
        var num:CGFloat = 0
        
        for point in points {
            sum += point.x
            num += 1
        }
        
        return sum / num
    }
    
    public func lowerBoundedY(boundY: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: max(self.y, boundY))
    }
    
    public func upperBoundedY(boundY: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: min(self.y, boundY))
    }

    public func distanceTo(point:CGPoint) -> CGFloat {
        
        let dx = point.x - self.x
        let dy = point.y - self.y
        
        return sqrt(dx * dx + dy * dy) //* signbit(dx) * signbit(dy)
    }
    
    public func angleBetween(point:CGPoint) -> CGFloat {
        let dx = point.x - self.x
        let dy = point.y - self.y
        
        return atan(dy/dx)
    }
    
    static public func minX(p1: CGPoint, p2: CGPoint) -> CGPoint {
        
        if (p1.x == p2.x) {
            return p1.y < p2.y ? p1 : p2
        }
        return abs(p1.x) < abs(p2.x) ? p1 : p2
    }
    
    static public func maxX(p1: CGPoint, p2: CGPoint) -> CGPoint {
        
        if (p1.x == p2.x) {
            return p1.y >= p2.y ? p1 : p2
        }
        return abs(p1.x) >= abs(p2.x) ? p1 : p2
    }
}

public extension CGVector {
    
    //Can add vectors
    static public func + (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    //Can sub vectors
    static public func - (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    //Can add vectors and sizes (dx + width) (dy + height)
    static public func + (left: CGVector, right: CGSize) -> CGVector {
        return CGVector(dx: left.dx + right.width, dy: left.dy + right.height)
    }
    
    //Can sub vectors and sizes (dx - width) (dy - height)
    static public func - (left: CGVector, right: CGSize) -> CGVector {
        return CGVector(dx: left.dx - right.width, dy: left.dy - right.height)
    }
    
    //Scalar Multiplication
    static public func * (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx * right, dy: left.dy * right)
    }
    
    //Scalar Division
    static public func / (left: CGVector, right: CGFloat) -> CGVector {
        return CGVector(dx: left.dx / right, dy: left.dy / right)
    }
    
    public func speed() -> CGFloat {
        
        return sqrt((self.dx * self.dx) + (self.dy * self.dy))
    }
    
    public mutating func reduceToSpeed(newSpeed: CGFloat) {
        let ang = atan(self.dy / self.dx)
        
        self.dx = newSpeed * cos(ang) * signbit(self.dx)
        self.dy = newSpeed * abs(sin(ang)) * signbit(self.dy)
    }
    
    public static func vectorWithForceAndAngle(force: CGFloat, angle: CGFloat) -> CGVector {
        
        
        let dx = force * cos(angle)
        let dy = force * sin(angle)
        
        return CGVector(dx: dx, dy: dy)
        
    }
}

public extension CGSize {
    static public func / (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width / right.width, height: left.height / right.height)
    }
    
    static public func / (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(width: left.width / right, height: left.height / right)
    }
}

public func signbit(_ n: CGFloat) -> CGFloat {
    return n < 0 ? -1 : 1
}

extension CGPoint: Hashable {
    public var hashValue: Int {
        
        //Taken from a Java implementation, but multiplied by 1000 for 0.001 accuracy (plenty for my usage). 31 is used as its prime
        var result = x * 1000;
        result = 31 * result + y * 1000;
        return Int(result);
    }

    
}

