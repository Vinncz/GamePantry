import Foundation

public struct GPBlacklistedEvent : GPEvent {
    
    public let who         : MCPeerID
    
    public let purpose     : String

    public let time        : Date

    public let payload     : [ String : Any ]?
    
    public init ( who: MCPeerID, payload: [ String : Any ]? ) {
        self.who         = who
        self.purpose     = "An event that marks a peer as blacklisted."
        self.time        = .now
        self.payload     = payload
    }
    
}
