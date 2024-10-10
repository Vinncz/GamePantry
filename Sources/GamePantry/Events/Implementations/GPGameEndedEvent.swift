public struct GPGameEndedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let effectiveOn     : String
    
    public let id              : String = "GPGameEndedEvent"
    public let purpose         : String = "Notify the client that the game had ended"
    public let instanciatedOn  : Date   = .now
    
    public var payload         : [String : Any] = [:]
    
    public init ( effectiveOn activeOn: Date ) {
        effectiveOn = activeOn.ISO8601Format()
    }
    
    public init ( effectiveOn activeOn: String ) {
        effectiveOn = activeOn
    }
    
}

extension GPGameEndedEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             effectiveOn = "effectiveOn"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPGameEndedEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.effectiveOn.rawValue : self.effectiveOn
            ]
        } ?? Data()
    }
    
}

extension GPGameEndedEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GPGameEndedEvent? {
        guard
            "GPGameEndedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let effectiveOn = payload[PayloadKeys.effectiveOn.rawValue] as? String
        else {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        guard let effectiveOn = dateFormatter.date(from: effectiveOn) else {
            return nil
        }
        
        return GPGameEndedEvent(effectiveOn: effectiveOn)
    }
    
}
