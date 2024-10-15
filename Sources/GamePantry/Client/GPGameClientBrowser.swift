import Combine
import MultipeerConnectivity

public typealias GPGameClientBrowser = GPGameClientBrowserProtocol & GPGameClientBrowserSC

public protocol GPGameClientBrowserProtocol {
    
    func unableToBrowse ( error: Error )
    
    func didFindJoinableServer ( _ serverId: MCPeerID, with discoveryInfo: [String: String]? )
    
    func didLoseJoinableServer ( _ serverId: MCPeerID )
    
}

open class GPGameClientBrowserSC : NSObject, ObservableObject {
    
    private var browser         : ClientBrowser!
    private class ClientBrowser : MCNearbyServiceBrowser, MCNearbyServiceBrowserDelegate {
        
        weak var attachedTo        : GPGameClientBrowser?
             let serverServiceType : String
        
        init ( for browser: GPGameClientBrowser, serverServiceType: String ) {
            self.attachedTo        = browser
            self.serverServiceType = serverServiceType
            
            super.init (
                peer        : browser.browsingFor, 
                serviceType : serverServiceType
            )
            
            self.delegate = self
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
    
    @Published public var discoveredServers : [GPGameServerDiscoveryReport] 
    
    public let browsingFor : MCPeerID
    public let serviceType : String
    
    public init ( serves target: MCPeerID, serviceType: String ) {
        self.browsingFor = target
        self.serviceType = serviceType
        
        self.discoveredServers  = []
        
        super.init()
    }
    
}

extension GPGameClientBrowserSC {
    
    public final func startBrowsing ( _ instance: GPGameClientBrowser ) {
        instance.browser = ClientBrowser (
            for               : instance, 
            serverServiceType : instance.serviceType
        )
        instance.browser.startBrowsingForPeers()
    }
    
    public final func stopBrowsing ( _ instance: GPGameClientBrowser ) {
        instance.browser.stopBrowsingForPeers()
    }
    
}

extension GPGameClientBrowserSC {
    
    public final func requestToJoin ( _ who: MCPeerID ) -> ( _ broadcasterSignature: MCSession ) -> Void {
        return { ba in
            self.browser.invitePeer(who, to: ba, withContext: nil, timeout: 5)
        }
    }
    
}
