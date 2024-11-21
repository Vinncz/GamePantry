import Combine
import MultipeerConnectivity

/// The base type for objects which searches for joinable servers in the network.
/// 
/// # Overview
/// Use in tandem with ``GPGameServerBroadcaster``, to create the cycle of searching and joining servers in the network.
/// 
/// # Usage
/// Treat the ``GPGameClientBrowser`` object as a pair of binoculars, from which you can search for servers in the network.
/// You can choose to start or stop looking by calling ``startBrowsing(_:)`` and ``stopBrowsing(_:)`` respectively.
/// 
/// ```swift
/// let binoculars = MyBinoculars()    // A class that conforms to GPGameClientBrowserProtocol
///     binoculars.startBrowsing(self) // Binoculars will now search for joinable servers, and you can see them through the methods of MyBinoculars
///     binoculars.stopBrowsing(self)   // Binoculars will no longer search for joinable servers
/// ```
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
    
    public final func requestToJoin ( _ subject: MCPeerID, payload: Data? = nil, validFor: TimeInterval? = nil ) -> ( _ broadcasterSignature: MCSession ) -> Void {
        return { [weak self] ba in
            self?.browser?.invitePeer(subject, to: ba, withContext: payload, timeout: validFor ?? self?.gameProcessConfiguration.timeout ?? 20)
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
