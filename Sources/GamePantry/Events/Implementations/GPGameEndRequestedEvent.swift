public struct GPGameEndRequestedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let signingKey     : String
    
    public let id             : String = "GPGameEndRequestedEvent"
    public let purpose        : String = "Only sent by client-host to server, indicating that it require for the game to be ended"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String : Any] = [:]
    
    public init ( authorizedBy: String ) {
        signingKey = authorizedBy
    }
    
}

extension GPGameEndRequestedEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId    = "eventId",
             signingKey = "signingKey"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPGameEndRequestedEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue    : self.id,
                PayloadKeys.signingKey.rawValue : self.signingKey
            ]
        } ?? Data()
    }
    
}

extension GPGameEndRequestedEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GPGameEndRequestedEvent? {
        guard
            "GPGameEndRequestedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let signingKey = payload[PayloadKeys.signingKey.rawValue] as? String
        else {
            return nil
        }
        
        return GPGameEndRequestedEvent(authorizedBy: signingKey)
    }
    
}
