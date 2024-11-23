public struct GPGameJoinRequestedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subjectId      : String
    public let subjectName    : String
    
    public let id             : String = "GPGameJoinRequestedEvent"
    public let purpose        : String = "Notify the server and the client-host, that a player wants to join the room"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String: Any] = [:]
    
    public init ( requestedBy id: String, named name: String ) {
        subjectId   = id
        subjectName = name
    }
    
}

extension GPGameJoinRequestedEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             subjectId   = "subjectId",
             subjectName = "subjectName"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPGameJoinRequestedEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.subjectId.rawValue   : self.subjectId,
                PayloadKeys.subjectName.rawValue : self.subjectName
            ]
        } ?? Data()
    }
    
}

extension GPGameJoinRequestedEvent {
    
    public static func construct ( from payload: [String: Any] ) -> GPGameJoinRequestedEvent? {
        guard 
            "GPGameJoinRequestedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subjectId   = payload[PayloadKeys.subjectId.rawValue] as? String,
            let subjectName = payload[PayloadKeys.subjectName.rawValue] as? String 
        else {
            return nil
        }
        
        return GPGameJoinRequestedEvent(requestedBy: subjectId, named: subjectName)
    }
    
}
