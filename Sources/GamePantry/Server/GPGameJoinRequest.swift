import MultipeerConnectivity

/// A request to join a game, readable by the game server.
public struct GPGameJoinRequest : Hashable {
    
    public var requesteeAddress : MCPeerID
    public var requestContext   : Data?
    public var admitterObject   : ( _ resolveToAdmit: Bool, MCSession? ) -> Void
    
    static public func == ( lhs: GPGameJoinRequest, rhs: GPGameJoinRequest ) -> Bool {
        lhs.requesteeAddress == rhs.requesteeAddress && lhs.requestContext == rhs.requestContext 
    }
    
    public func hash ( into hasher: inout Hasher ) {
        hasher.combine(requesteeAddress)
        hasher.combine(requestContext)
    }
    
    public init ( requestee: MCPeerID, requestContext: Data? = nil, admitterObject: @escaping (_: Bool, MCSession?) -> Void ) {
        self.requesteeAddress = requestee
        self.requestContext   = requestContext
        self.admitterObject   = admitterObject
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
