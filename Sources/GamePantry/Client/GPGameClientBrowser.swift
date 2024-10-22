import Combine
import MultipeerConnectivity

public typealias GPGameClientBrowser = GPGameClientBrowserProtocol & GPGameClientBrowserSC

public protocol GPGameClientBrowserProtocol {
    
    func unableToBrowse ( error: Error )
    
    func didFindJoinableServer ( _ serverId: MCPeerID, with discoveryInfo: [String: String]? )
    
    func didLoseJoinableServer ( _ serverId: MCPeerID )
    
}

open class GPGameClientBrowserSC : NSObject, ObservableObject {
    
    private var browser         : ClientBrowser?
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
    public let gameProcessConfiguration : GPGameProcessConfiguration
    
    public init ( serves target: MCPeerID, configuredWith: GPGameProcessConfiguration ) {
        self.browsingFor              = target
        self.gameProcessConfiguration = configuredWith
        
        self.discoveredServers = []
        
        super.init()
    }
    
}

extension GPGameClientBrowserSC {
    
    public final func startBrowsing ( _ instance: GPGameClientBrowser ) {
        if ( instance.browser != nil ) {
            instance.browser?.stopBrowsingForPeers()
            instance.browser = nil
            instance.discoveredServers.removeAll()
        }
        
        instance.browser = ClientBrowser (
            for               : instance, 
            serverServiceType : instance.gameProcessConfiguration.serviceType
        )
        instance.browser?.startBrowsingForPeers()
    }
    
    public final func stopBrowsing ( _ instance: GPGameClientBrowser ) {
        instance.browser?.stopBrowsingForPeers()
        instance.browser = nil
    }
    
}

extension GPGameClientBrowserSC {
    
    public final func requestToJoin ( _ who: MCPeerID ) -> ( _ broadcasterSignature: MCSession ) -> Void {
        return { [weak self] ba in
            self?.browser?.invitePeer(who, to: ba, withContext: nil, timeout: self?.gameProcessConfiguration.timeout ?? 10)
        }
    }
    
}

extension GPGameClientBrowserSC {
    
    public final func reset () {
        self.browser?.stopBrowsingForPeers()
        self.browser = nil
        self.discoveredServers.removeAll()
    }
    
}
