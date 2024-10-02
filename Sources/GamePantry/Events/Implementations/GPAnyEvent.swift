public class GPAnyEvent : GPEvent {
    
    public var purpose : String
    public var time    : Date
    public var payload : [String: Any]
    
    public init ( purpose: String, time: Date, payload: [String: Any] ) {
        self.purpose = purpose
        self.time    = time
        self.payload = payload
    }
    
    public convenience init ( _ preparedEvent: GPEvent ) {
        self.init (
            purpose : preparedEvent.purpose,
            time    : preparedEvent.time,
            payload : preparedEvent.payload
        )
    }
    
}
