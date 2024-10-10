import MultipeerConnectivity

public struct GPAcquaintanceStatusUpdateEvent : GPEvent {
    
    public let subject : MCPeerID
    public let status  : MCSessionState
    
    public let id             : String = "GPAcquaintanceStatusUpdateEvent"
    public let purpose        : String = "Marks a change in acquaintance status"
    public let instanciatedOn : Date   = .now
    
    public init ( subject: MCPeerID, status: MCSessionState ) {
        self.subject = subject
        self.status  = status
    }
    
}
