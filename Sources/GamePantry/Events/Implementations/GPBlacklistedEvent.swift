import MultipeerConnectivity

public struct GPBlacklistedEvent : GPEvent {
    
    public let who         : MCPeerID
    public let reason      : String
    
    public let purpose     : String
    public let time        : Date
    public let payload     : [String: Any]?
    
    public init ( who: MCPeerID, reason: String, payload: [String: Any]? ) {
        self.who         = who
        self.reason      = reason
        
        self.purpose     = "An event that marks a peer as blacklisted."
        self.time        = .now
        self.payload     = payload
    }
    
    public func representation () -> Data {
        return (
            try? JSONSerialization.data (
                withJSONObject: [ 
                    "who"     : who,
                    "purpose" : purpose,
                    "time"    : time,
                    "payload" : payload ?? [:]
                ], 
                options: .prettyPrinted
            )
        ) ?? Data()
    }
    
}

extension GPBlacklistedEvent {
    
    public enum payloadKeys : String {
        case reason = "causeOfBlacklist"
    }
    
}
