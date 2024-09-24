import Foundation

public protocol GPHoldsEvents {
    
    var log : [GPEvent] { get }
    
    func log ( event: GPEvent )
    
}
