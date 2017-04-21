import Cocoa


public class Queue<T> {
    
    public var queueArray:[T] = []
    public var currentIndex = 0
    public var size = 0
    
    public init(_ objects:[T]!) {
        queueArray = objects
        size = objects.count
    }
    
    public init() {
        
    }
    
    public func push(_ obj: T) {
        queueArray.append(obj)
        size += 1
    }
    
    public func pop() -> T? {
        if currentIndex < size {
            currentIndex += 1
            return queueArray[currentIndex - 1]
        }
        
        return nil
    }
}
