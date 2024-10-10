public struct GPGameStartRequestedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let signingKey     : String
    
    public let id             : String = "GPGameStartRequestedEvent"
    public let purpose        : String = "Only sent by client-host to server, indicating that it require for the game to be commenced"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String : Any] = [:]
    
    public init ( authorizedBy: String ) {
        signingKey = authorizedBy
    }
    
}

extension GPGameStartRequestedEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId    = "eventId",
             signingKey = "signingKey"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPGameStartRequestedEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue    : self.id,
                PayloadKeys.signingKey.rawValue : self.signingKey
            ]
        } ?? Data()
    }
    
}

extension GPGameStartRequestedEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GPGameStartRequestedEvent? {
        guard
            "GPGameStartRequestedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let signingKey = payload[PayloadKeys.signingKey.rawValue] as? String
        else {
            return nil
        }
        
        return GPGameStartRequestedEvent(authorizedBy: signingKey)
    }
    
}
