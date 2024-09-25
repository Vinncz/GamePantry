import MultipeerConnectivity

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
        return { ba in
            if ( to == .admit ) {
                self.admitterObject(true, ba)
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