@available(*, deprecated)
public protocol GPHoldsEvents {
    
    var logs : [GPEvent] { get }
    
    func log ( event: GPEvent )
    
}
