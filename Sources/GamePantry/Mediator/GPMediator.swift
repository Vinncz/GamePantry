import Foundation

public protocol GPMediator {
    
    var mediated : [GPMediated] { get }
    
    func mediate ( _ event: GPEvent, recipients: [GPMediated] )
    
    func findMediated ( byUUID uuid: UUID ) -> GPMediated?
    
    func findMediated ( byName name: String ) -> GPMediated?
    
}
