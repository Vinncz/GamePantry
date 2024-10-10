public struct GPUnableToBrowseEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let cause          : String
    
    public let id             : String = "GPUnableToBrowseEvent"
    public let purpose        : String = "Notify the server and the client-host, that the room they're hosting, is unable to access the local network"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String: Any] = [:]
    
    public init ( dueTo: String ) {
        cause = dueTo
    }
    
}

extension GPUnableToBrowseEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId = "eventId",
             error   = "error"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPUnableToBrowseEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue : self.id,
                PayloadKeys.error.rawValue   : self.cause
            ]
        } ?? Data()
    }
    
}

extension GPUnableToBrowseEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GPUnableToBrowseEvent? {
        guard 
            "GPUnableToBrowseEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let errorMsg = payload[PayloadKeys.error.rawValue] as? String
        else {
            return nil
        }
        
        return GPUnableToBrowseEvent(dueTo: errorMsg)
    }
    
}
