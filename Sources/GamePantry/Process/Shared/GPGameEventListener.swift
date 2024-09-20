import MultipeerConnectivity

@Observable public class GPGameEventListener : NSObject {
    
    private var ear : Ear!
    private class Ear : NSObject, MCSessionDelegate {
        weak var attachedTo : GPGameEventListener?
        
        init ( for listener: GPGameEventListener ) {
            self.attachedTo = listener
        }
        
        func session ( _ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState ) {
            //
        }
        
        func session ( _ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardData( from: peerID, data: data )
        }
        
        func session ( _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardIncomingStreamRequest(from: peerID, stream, withContextOf: streamName)
        }
        
        func session ( _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress ) {
            attachedTo?.heardIncomingResourceRequest(from: peerID, withContextOf: resourceName, withProgressAt: progress)
        }
        
        func session ( _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)? ) {
            attachedTo?.heardCompletionOfResourceTransfer(context: resourceName, sender: peerID, savedAt: localURL, withAccompanyingErrorOf: error)
        }
        
    }
    
    public var listeningTo : Set<MCPeerID> = []
    
    public override init () {
        super.init()
        self.ear = Ear( for: self )
    }
    
    public final func portAsDelegate () -> MCSessionDelegate {
        return ear
    }
    
    public func heardData ( from peer: MCPeerID, data: Data ) {
        fatalError("Subclasses must implement `heardDataTransmission`")
    }
    
    public func heardIncomingStreamRequest ( from peer: MCPeerID, _ stream: InputStream, withContextOf context: String ) {
        fatalError("Subclasses must implement `heardIncomingStreamRequest`")
    }
    
    public func heardIncomingResourceRequest ( from peer: MCPeerID, withContextOf context: String, withProgressAt progress: Progress ) {
        fatalError("Subclasses must implement `heardIncomingResourceRequest`")
    }
    
    public func heardCompletionOfResourceTransfer ( context: String, sender: MCPeerID, savedAt: URL?, withAccompanyingErrorOf: (any Error)? ) {
        fatalError("Subclasses must implement `heardResourceTransferComplete")
    }
        
}

public class RPSEL : GPGameEventListener {
    override public func heardData(from peer: MCPeerID, data: Data) {
        //
    } 
}

public class RPSEB : GPGameEventBroadcaster {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
}
