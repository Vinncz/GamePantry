import MultipeerConnectivity

/// The base type for objects which advertises a joinable game server.
/// 
/// # Overview
/// Use in tandem with ``GPGameClientBrowser`` to create the discovery-then-join system for multiplayer functionality.
/// 
/// ``GPGameServerAdvertiser`` has the responsibility to publicize the availability of a joinable game server to the network. 
/// 
/// # Usage
/// Treat the ``GPGameServerAdvertiser`` object as a torchlight, from which you can toggle the joinable state of the server,
/// by calling ``startAdvertising(what:on:)`` and ``stopAdvertising(on:)`` respectively.
/// 
/// Once self is advertising, the ``GPGameServerAdvertiser`` will listen for incoming requests to join the game server.
/// 
/// ```swift
/// let advertiserObj = MyGameServerAdvertiser() // A class that conforms to GPGameServerAdvertiserProtocol
/// let browserObj    = MyGameClientBrowser()    // A class that conforms to GPGameClientBrowserProtocol
/// 
/// advertiserObj.startAdvertising (what:
///    ["gameName": "MyGame", "gameMode": "Multiplayer"],
///    on: advertiserObj
/// )
/// 
/// browserObj.startBrowsing(on: browserObj)
/// ```
public typealias GPGameServerAdvertiser = GPGameServerAdvertiserSC & GPGameServerAdvertiserProtocol

/// The base protocol for objects which advertises a joinable game server.
/// 
/// # Overview
/// Use the ``GPGameServerAdvertiserProtocol`` to facade the methods of ``MCNearbyServiceAdvertiserDelegate`` to a readable and more contextual form.
/// 
/// - Warning: Refrain from implementing this protocol outside the environment of GamePantry framework. This was made public since Swift limits public typealiases to only reference types which are public.
public protocol GPGameServerAdvertiserProtocol {
    
    /// Called when self is unable to advertise the game server.
    func unableToAdvertise ( error: Error )
    
    /// Called when self gets a join request from a peer.
    func didReceiveAdmissionRequest ( from peer: MCPeerID, withContext: Data?, admitterObject: @escaping (Bool, MCSession?) -> Void )
    
}

/// The base class for objects which advertises a joinable game server.
/// 
/// # Overview
/// Abstracts the implementation of ``MCNearbyServiceAdvertiserDelegate``, and maps the methods related to incoming requests to join the game server to the methods of a given ``GPGameServerAdvertiserProtocol`` object through initialization.
/// 
/// # Usage
/// Treat the ``GPGameServerAdvertiser`` object as a torchlight, from which you can toggle the joinable state of the server,
/// by calling ``startAdvertising(what:on:)`` and ``stopAdvertising(on:)`` respectively.
/// 
/// - Warning: Refrain from implementing this class outside the environment of GamePantry framework. This was made public since Swift limits public typealiases to only reference types which are public.
open class GPGameServerAdvertiserSC : NSObject, ObservableObject {
    
    private var service : AdvertiserService?
    private class AdvertiserService : MCNearbyServiceAdvertiser, MCNearbyServiceAdvertiserDelegate {
        
        weak var attachedTo : GPGameServerAdvertiser?
        var advertContent   : [String : String]
        
        init ( for advertiser: GPGameServerAdvertiser, serviceType: String, advertContent: [String : String] = [:] ) {
            self.attachedTo    = advertiser
            self.advertContent = advertContent

            super.init (
                peer          : advertiser.advertisingFor, 
                discoveryInfo : advertContent, 
                serviceType   : serviceType
            )
        }
        
        func advertiser ( _ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void ) {
            attachedTo?.didReceiveAdmissionRequest (
                from           : peerID,
                withContext    : context,
                admitterObject : invitationHandler
            )
            self.attachedTo?.isAdvertising = true 
        }
        
        func advertiser ( _ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: any Error ) {
            attachedTo?.unableToAdvertise(error: error)
            self.attachedTo?.isAdvertising = false
        }
        
    }
    
    @Published public var pendingRequests : [GPGameJoinRequest]
    @Published public var isAdvertising   : Bool
    
    public let advertisingFor : MCPeerID
    public let gameProcessConfiguration : GPGameProcessConfiguration
    
    public init ( serves target: MCPeerID, configuredWith: GPGameProcessConfiguration ) {
        self.gameProcessConfiguration = configuredWith
        self.advertisingFor           = target
        self.isAdvertising            = false
        self.pendingRequests          = []
        
        super.init()
    }
    
}

extension GPGameServerAdvertiserSC {
    
    public final func startAdvertising ( what content: [String: String], on instance: GPGameServerAdvertiser ) {
        if ( instance.service != nil ) {
            stopAdvertising(on: instance)
        }
        instance.service = nil
        
        instance.service = AdvertiserService ( 
            for: instance,
            serviceType: instance.gameProcessConfiguration.serviceType,
            advertContent: content
        )
        if let service = instance.service {
            service.delegate = self.service
            service.startAdvertisingPeer()
            self.isAdvertising = true
        }
    }
    
    public final func stopAdvertising ( on instance: GPGameServerAdvertiser ) {
        if let service = instance.service {
            service.stopAdvertisingPeer()
            instance.service = nil
            instance.pendingRequests.removeAll()
            self.isAdvertising = false
        }
    }
    
}
