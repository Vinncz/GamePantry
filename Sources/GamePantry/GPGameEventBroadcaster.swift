import MultipeerConnectivity

open class GPGameEventBroadcaster : NSObject {
    
    private var emitter : Emitter!
    private class Emitter : MCSession {
        
        weak var attachedTo : GPGameEventBroadcaster?
        
        init ( for broadcaster: GPGameEventBroadcaster ) {
            self.attachedTo = broadcaster
            super.init (
                peer                 : broadcaster.broadcastingFor,
                securityIdentity     : nil,
                encryptionPreference : .none
            )
        }
        
    }
    public let broadcastingFor : MCPeerID
    
    public init ( serves target: MCPeerID ) {
        self.broadcastingFor = target
        
        super.init()
        
        self.emitter = Emitter(for: self)
    }
    
}

extension GPGameEventBroadcaster {
    
    public final func broadcast ( _ event: Data, to recipients: [MCPeerID] ) throws {
        try self.emitter.send(event, toPeers: recipients, with: .reliable)
    }
    
    public final func send ( resourceAt: URL, to: MCPeerID, context: String, eventHandler: (((any Error)?) -> Void)? ) -> Progress? {
        return self.emitter.sendResource(at: resourceAt, withName: context, toPeer: to, withCompletionHandler: eventHandler)
    }
    
    public final func stream ( _ stream: InputStream, context: String, to: MCPeerID ) throws -> OutputStream {
        return try self.emitter.startStream(withName: context, toPeer: to)
    }
    
    public final func ceaseCommunication () {
        self.emitter.disconnect()
    }
    
}

extension GPGameEventBroadcaster {
    
    public final func pair ( _ eventListener: GPGameEventListener ) -> Self {
        self.emitter.delegate = eventListener.portAsDelegate()
        return self
    }
    
    public final func approve ( _ request : @escaping ( _ signed: MCSession ) -> Void ) {
        request(self.emitter)
    }
    
}

extension GPGameEventBroadcaster {
    
    public final func getPeers () -> [MCPeerID] {
        return self.emitter.connectedPeers
    }
    
}
