import MultipeerConnectivity

/// A request to join a game, readable by the game server.
public struct GPGameJoinRequest : Hashable {
    
    public var requestee      : MCPeerID
    public var requestContext : Data?
    public var admitterObject : ( _ resolveToAdmit: Bool, MCSession? ) -> Void
    
    static public func == ( lhs: GPGameJoinRequest, rhs: GPGameJoinRequest ) -> Bool {
        lhs.requestee == rhs.requestee && lhs.requestContext == rhs.requestContext 
    }
    
    public func hash ( into hasher: inout Hasher ) {
        hasher.combine(requestee)
        hasher.combine(requestContext)
    }
    
    public init ( requestee: MCPeerID, requestContext: Data? = nil, admitterObject: @escaping (_: Bool, MCSession?) -> Void ) {
        self.requestee      = requestee
        self.requestContext = requestContext
        self.admitterObject = admitterObject
    }
    
    public func resolve ( to: Resolve ) -> ( _ broadcasterSignature : MCSession ) -> Void {
        return { bs in
            if ( to == .admit ) {
                self.admitterObject(true, bs)
            } else {
                self.admitterObject(false, nil)
            }
        }
    }
    
    public enum Resolve {
        case admit,
             reject
    }
    
}
