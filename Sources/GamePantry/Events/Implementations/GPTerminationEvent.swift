import MultipeerConnectivity

public struct GPTerminationEvent : GPEvent {
    
    public let who     : MCPeerID
    public let validOn : Date

    public let purpose : String
    public let time    : Date
    public let payload : [String: Any]?
    
    public init ( who: MCPeerID, validOn: Date, payload: [String: Any]? ) {
        self.who     = who
        self.validOn = validOn
        
        self.purpose = "An event that marks the termination of relationship of a game client with the server its connected to."
        self.time    = .now
        self.payload = nil
    }
    
    public func representation () -> Data {
        return (
            try? JSONSerialization.data (
                withJSONObject: [
                    "who"     : who,
                    "validOn" : validOn,
                    "purpose" : purpose,
                    "time"    : time,
                    "payload" : payload ?? [:]
                ],
                options: .prettyPrinted
            )
        ) ?? Data()
    }
}

extension GPTerminationEvent {
    
    public enum payloadKeys : String {
        case verificationKey     = "verificationKey",
             terminationReason   = "causeOfTermination"
    }
    
}
