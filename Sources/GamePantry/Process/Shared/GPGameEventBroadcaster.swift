import MultipeerConnectivity

@Observable open class GPGameEventBroadcaster : NSObject {
    
    private var emitter : Emitter!
    private class Emitter : MCSession {
        
        weak var attachedTo : GPGameEventBroadcaster?
        
        init ( for broadcaster: GPGameEventBroadcaster ) {
            self.attachedTo = broadcaster
            super.init (
                peer: broadcaster.broadcastingFor, 
                securityIdentity: nil, 
                encryptionPreference: .none
            )
        }
        
    }
    
    public let broadcastingFor : MCPeerID
    public var broadcastingTo  : [MCPeerID] {
        return self.emitter.connectedPeers
    }
    
    public init ( serves target: MCPeerID ) {
        self.broadcastingFor = target
        super.init()
        self.emitter = Emitter(for: self)
    }
    
    public final func pair ( _ eventListener: GPGameEventListener ) -> Self {
        self.emitter.delegate = eventListener.portAsDelegate()
        return self
    }
    
    public final func help () -> MCSession {
        return self.emitter
    }
    
    public final func broadcast ( _ event: Data, to: [MCPeerID] ) throws {
        try self.emitter.send(event, toPeers: to, with: .reliable)
    }
    
    public final func send ( resourceAt: URL, to: MCPeerID, context: String, eventHandler: (((any Error)?) -> Void)? ) -> Progress? {
        return self.emitter.sendResource(at: resourceAt, withName: context, toPeer: to, withCompletionHandler: eventHandler)
    }
    
    public final func stream ( _ stream: InputStream, context: String, to: MCPeerID ) throws -> OutputStream {
        return try self.emitter.startStream(withName: context, toPeer: to)
    }
    
}
