import MultipeerConnectivity

public struct GPAcquaintanceEvent : GPEvent {
    
    public let who     : MCPeerID
    public let newState: MCSessionState
    
    public var purpose : String
    public var time    : Date
    public var payload : [String: Any]?

    public init ( who: MCPeerID, newState: MCSessionState, payload: [String: Any]? ) {
        self.who      = who
        self.newState = newState
        
        self.purpose  = "An event which indicates that the state of one's acquaintance has changed."
        self.time     = .now
        self.payload  = payload
    }
    
}
