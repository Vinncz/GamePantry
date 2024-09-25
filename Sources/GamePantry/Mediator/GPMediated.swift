import Foundation

public protocol GPMediated {
    
    var medID : UUID { get }
    
    var mediator : GPMediator? { get set }
    
}

extension GPMediated {
    
    public var name : String {
        let processInfo = ProcessInfo.processInfo
        let trimmedHostName = processInfo.hostName.split(separator: ".").last ?? ""
        let identifier = "\(trimmedHostName)-\(medID.uuidString)"
        
        return  identifier
    }
    
}
