public struct GPAnyEvent : GPEvent {
    
    public let containedEvent : GPEvent
    
    public let id             : String = "GPAnyEvent"
    public let purpose        : String = "A generic event"
    public let instanciatedOn : Date   = .now
    
    public init ( _ event: GPEvent ) {
        self.containedEvent = event
    }
    
}
