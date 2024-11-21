/// The base protocol for all events.
public protocol GPEvent {
    
    /// Uniquely identifies one type of event from another.
    var id             : String { get }
    
    /// Human-readable description of what the event is for.
    var purpose        : String { get }
    
    /// Creation date of the event.
    var instanciatedOn : Date   { get }
    
}
