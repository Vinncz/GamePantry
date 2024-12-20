public struct GPGameJoinVerdictDeliveredEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subjectName : String
    public let isAdmitted  : Bool
    public let signingKey  : String
    
    public let id             : String = "GPGameJoinVerdictDeliveredEvent"
    public let purpose        : String = "Notify the server that the client-host has drafted a verdict for a player's join request"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String: Any] = [:]
    
    public init ( forName: String, verdict: Bool, authorizedBy: String ) {
        subjectName = forName
        isAdmitted  = verdict
        signingKey  = authorizedBy
    }
    
}

extension GPGameJoinVerdictDeliveredEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             subjectName = "subjectName",
             isAdmitted  = "isAdmitted",
             authorizedBy = "authorizedBy"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GPGameJoinVerdictDeliveredEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.subjectName.rawValue : self.subjectName,
                PayloadKeys.isAdmitted.rawValue  : self.isAdmitted.description,
                PayloadKeys.authorizedBy.rawValue : self.signingKey
            ]
        } ?? Data()
    }
    
}

extension GPGameJoinVerdictDeliveredEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GPGameJoinVerdictDeliveredEvent? {
        guard 
                "GPGameJoinVerdictDeliveredEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subjectName                        = payload[PayloadKeys.subjectName.rawValue] as? String,
            let isAdmitted                         = Bool(payload[PayloadKeys.isAdmitted.rawValue] as? String ?? "false"),
            let signingKey                         = payload[PayloadKeys.authorizedBy.rawValue] as? String
        else {
            return nil
        }
        
        return GPGameJoinVerdictDeliveredEvent(forName: subjectName, verdict: isAdmitted, authorizedBy: signingKey)
    }
    
}
