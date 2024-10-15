public struct GPTerminatedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subject    : String
    public let reason     : String
    public let signingKey : String
        
    public let id             : String = "GPTerminatedEvent"
    public let purpose        : String = "A nuclear way that signals a peer to disconnect themselves"
    public let instanciatedOn : Date   = .now
    
    public var payload : [String: Any] = [:]
    
    public init ( subject: String, reason: String, authorizedBy: String, payload: [String: Any] = [:] ) {
        self.subject    = subject
        self.reason     = reason
        self.payload    = payload
        self.signingKey = authorizedBy
    }
    
}

extension GPTerminatedEvent /* : GPHoldsPayload */ {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId      = "eventId",
             subject      = "subject",
             reason       = "reason",
             authorizedBy = "authorizedBy"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPTerminatedEvent /* : GPRepresentableAsData */ {
    
    public func representedAsData () -> Data {
        return dataFrom {
            [
                PayloadKeys.eventId.rawValue : self.id,
                PayloadKeys.subject.rawValue : self.subject,
                PayloadKeys.reason.rawValue  : self.reason,
                PayloadKeys.authorizedBy.rawValue : self.signingKey
            ]
        } ?? Data()
    }
    
}

extension GPTerminatedEvent /* : GPConstructibleFromPayload */ {
    
    public static func construct ( from payload: [String: Any] ) -> GPTerminatedEvent? {
        guard
                "GPTerminatedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subject              = payload[PayloadKeys.subject.rawValue] as? String,
            let reason               = payload[PayloadKeys.reason.rawValue] as? String,
            let signingKey           = payload[PayloadKeys.authorizedBy.rawValue] as? String
        else {
            return nil
        }
        
        return GPTerminatedEvent(subject: subject, reason: reason, authorizedBy: signingKey, payload: payload)
    }
    
}
