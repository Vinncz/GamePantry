import MultipeerConnectivity

public typealias GPGameClientBrowser = GPGameClientBrowserProtocol & GPGameClientBrowserSC

public protocol GPGameClientBrowserProtocol {
    
    func unableToBrowse ( error: Error )
    
    func didFindJoinableServer ( _ serverId: MCPeerID, with discoveryInfo: [String: String]? )
    
    func didLoseJoinableServer ( _ serverId: MCPeerID )
    
}

public class GPGameClientBrowserSC : NSObject {
    
    private var browser: ClientBrowser!
    private class ClientBrowser : MCNearbyServiceBrowser, MCNearbyServiceBrowserDelegate {
        
        weak var attachedTo   : GPGameClientBrowser?
        let serverServiceType : String
        
        init ( for browser: GPGameClientBrowser, serverServiceType: String ) {
            self.attachedTo        = browser
            self.serverServiceType = serverServiceType
            
            super.init (
                peer        : browser.browsingFor, 
                serviceType : serverServiceType
            )
        }
        
        func browser ( _ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: any Error ) {
            attachedTo?.unableToBrowse(error: error)
        }
        
        func browser ( _ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]? ) {
            attachedTo?.didFindJoinableServer(peerID, with: info)
        }
        
        func browser ( _ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID ) {
            attachedTo?.didLoseJoinableServer(peerID)
        }
        
    }
    
    public let browsingFor       : MCPeerID
    public let serverServiceType : String
    
    public init ( serves target: MCPeerID, serviceType: String ) {
        self.browsingFor       = target
        self.serverServiceType = serviceType
        
        super.init()
    }
    
    public final func wake ( _ instance: GPGameClientBrowser ) {
        instance.browser = ClientBrowser (
            for               : instance, 
            serverServiceType : instance.serverServiceType
        )
    }
    
}
