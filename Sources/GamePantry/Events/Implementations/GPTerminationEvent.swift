import MultipeerConnectivity

public struct GPTerminationEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subject : String
    public let reason  : String
        
    public let id             : String = "GPTerminationEvent"
    public let purpose        : String = "A nuclear way that signals a peer to disconnect themselves"
    public let instanciatedOn : Date   = .now
    
    public var payload : [String: Any] = [:]
    
    public init ( subject: String, reason: String, payload: [String: Any] = [:] ) {
        self.subject = subject
        self.reason  = reason
        self.payload = payload
    }
    
}

extension GPTerminationEvent /* : GPHoldsPayload */ {
    
    public enum PayloadKeys : String, CaseIterable {
        case subject = "subject",
             reason  = "reason"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPTerminationEvent /* : GPRepresentableAsData */ {
    
    public func representedAsData () -> Data {
        return dataFrom {
            [
                PayloadKeys.subject.rawValue : self.subject,
                PayloadKeys.reason.rawValue  : self.reason
            ]
        } ?? Data()
    }
    
}

extension GPTerminationEvent /* : GPConstructibleFromPayload */ {
    
    public static func construct ( from payload: [String: Any] ) -> GPTerminationEvent? {
        guard
            let subject = payload[PayloadKeys.subject.rawValue] as? String,
            let reason  = payload[PayloadKeys.reason.rawValue] as? String 
        else {
            return nil
        }
        
        return GPTerminationEvent(subject: subject, reason: reason, payload: payload)
    }
    
}
