import MultipeerConnectivity

public struct GPBlacklistedEvent : GPSendableEvent {
    
    public let subject : String
    public let reason  : String
        
    public let id             : String = "GPBlacklistedEvent"
    public let purpose        : String = "Marks a peer as blacklisted, and why you should avoid communicating with them"
    public let instanciatedOn : Date   = .now
    
    public var payload : [String: Any]
    
    public init ( subject: String, reason: String, payload: [String: Any] = [:] ) {
        self.subject = subject
        self.reason  = reason
        self.payload = payload
    }
    
}

extension GPBlacklistedEvent /* : GPHoldsPayload */ {
    
    public enum PayloadKeys : String, CaseIterable {
        case subject = "subject",
             reason  = "reason"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPBlacklistedEvent /* : GPRepresentableAsData */ {
    
    public func representedAsData () -> Data {
        return dataFrom {
            [
                PayloadKeys.subject.rawValue : self.subject,
                PayloadKeys.reason.rawValue  : self.reason
            ]
        } ?? Data()
    }
    
}

extension GPBlacklistedEvent /* : GPConstructibleFromPayload */ {
    
    public static func construct ( from payload: [String: Any] ) -> GPBlacklistedEvent? {
        guard 
            let subject = payload[PayloadKeys.subject.rawValue] as? String,
            let reason  = payload[PayloadKeys.reason.rawValue] as? String 
        else {
            return nil
        }
        
        return GPBlacklistedEvent(subject: subject, reason: reason, payload: payload)
    }
    
}
