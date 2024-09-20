import MultipeerConnectivity

@Observable public class GPGameEventBroadcaster : MCSession {
    
//    private var emitter : Emitter!
//    private class Emitter : MCSession {
//        
//    }
    
    public init ( serves target: MCPeerID, securityIdentity: [Any]? = nil, encryptionPreference: MCEncryptionPreference = .optional ) {
        super.init (
            peer: target, 
            securityIdentity: securityIdentity, 
            encryptionPreference: encryptionPreference
        )
    }
    
    public final func withDelegate ( of eventListener: GPGameEventListener ) {
        self.delegate = eventListener.portAsDelegate()
    }
    
}
