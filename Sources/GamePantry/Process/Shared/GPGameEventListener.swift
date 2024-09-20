import MultipeerConnectivity

public typealias GPGameEventListener = GPGameEventListenerSC & GPGameEventListenerProtocol

public protocol GPGameEventListenerProtocol {
    
    func heardStateChange ( of peer: MCPeerID, to state: MCSessionState )
    
    func heardData ( from peer: MCPeerID, _ data: Data )
    
    func heardIncomingStreamRequest ( from peer: MCPeerID, _ stream: InputStream, withContextOf context: String )
    
    func heardIncomingResourceTransfer ( from peer: MCPeerID, withContextOf context: String, withProgress progress: Progress )
    
    func heardCompletionOfResourceTransfer ( context: String, sender: MCPeerID, savedAt: URL?, withAccompanyingErrorOf: (any Error)? )
    
}

public class GPGameEventListenerSC : NSObject {
    
    private var ear : Ear!
    private class Ear : NSObject, MCSessionDelegate {
        
        weak var attachedTo : GPGameEventListener?
        
        init ( for listener: GPGameEventListener ) {
            self.attachedTo = listener
        }
        
        func session ( _ session: MCSession, peer peerID: MCPeerID, didChange newState: MCSessionState ) {
            attachedTo?.heardStateChange( of: peerID, to: newState )
        }
        
        func session ( _ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardData( from: peerID, data )
        }
        
        func session ( _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardIncomingStreamRequest(from: peerID, stream, withContextOf: streamName)
        }
        
        func session ( _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress ) {
            attachedTo?.heardIncomingResourceTransfer(from: peerID, withContextOf: resourceName, withProgress: progress)
        }
        
        func session ( _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)? ) {
            attachedTo?.heardCompletionOfResourceTransfer(context: resourceName, sender: peerID, savedAt: localURL, withAccompanyingErrorOf: error)
        }
        
    }
    
    public var listeningTo : Set<MCPeerID> = []
    
    public final func wake ( _ instance: GPGameEventListener ) {
        instance.ear = Ear( for: instance )
    }
    
    public final func portAsDelegate () -> MCSessionDelegate {
        return ear
    }
        
}
