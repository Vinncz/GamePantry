import MultipeerConnectivity

public typealias GPGameServerAdvertiser = GPGameServerAdvertiserSC & GPGameServerAdvertiserProtocol

public protocol GPGameServerAdvertiserProtocol {
    
    func unableToAdvertise ( error: Error )
    
    func didReceiveAdmissionRequest ( from peer: MCPeerID, withContext: Data?, admitterObject: @escaping (Bool, MCSession?) -> Void )
    
}

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
            attachedTo!.didReceiveAdmissionRequest (
                from           : peerID,
                withContext    : context,
                admitterObject : invitationHandler
            )
        }
        
        func advertiser ( _ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: any Error ) {
            attachedTo?.unableToAdvertise(error: error)
            self.attachedTo?.isAdvertising = false
        }
        
    }
    
    @Published public var pendingRequests : [GPGameJoinRequest]
    public let advertisingFor : MCPeerID
    public let serviceType    : String
    public var isAdvertising  : Bool
    
    public init ( serves target: MCPeerID, serviceType: String ) {
        self.serviceType     = serviceType
        self.advertisingFor  = target
        self.isAdvertising   = false
        
        self.pendingRequests = []
        
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
            serviceType: instance.serviceType,
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
            self.isAdvertising = false
        }
    }
    
}
