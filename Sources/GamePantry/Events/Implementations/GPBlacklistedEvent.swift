public struct GPBlacklistedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subject    : String
    public let reason     : String
    public let signingKey : String
        
    public let id             : String = "GPBlacklistedEvent"
    public let purpose        : String = "Marks a peer as blacklisted, and why you should avoid communicating with them"
    public let instanciatedOn : Date   = .now
    
    public var payload : [String: Any] = [:]
    
    public init ( subject: String, reason: String, authorizedBy: String, payload: [String: Any] = [:] ) {
        self.subject    = subject
        self.reason     = reason
        self.payload    = payload
        self.signingKey = authorizedBy
    }
    
}

extension GPBlacklistedEvent /* : GPHoldsPayload */ {
    
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

extension GPBlacklistedEvent /* : GPRepresentableAsData */ {
    
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

extension GPBlacklistedEvent /* : GPConstructibleFromPayload */ {
    
    public static func construct ( from payload: [String: Any] ) -> GPBlacklistedEvent? {
        guard 
                "GPBlacklistedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subject               = payload[PayloadKeys.subject.rawValue] as? String,
            let reason                = payload[PayloadKeys.reason.rawValue] as? String,
            let signingKey            = payload[PayloadKeys.authorizedBy.rawValue] as? String
        else {
            return nil
        }
        
        return GPBlacklistedEvent(subject: subject, reason: reason, authorizedBy: signingKey, payload: payload)
    }
    
}
