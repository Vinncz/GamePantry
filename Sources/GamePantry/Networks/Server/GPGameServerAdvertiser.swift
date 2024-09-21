import MultipeerConnectivity

public typealias GPGameServerAdvertiser = GPGameServerAdvertiserSC & GPGameServerAdvertiserProtocol

public protocol GPGameServerAdvertiserProtocol {
    
    func unableToAdvertise ( error: Error )
    
    func receivedAdmissionRequest ( from peer: MCPeerID, withContext: Data?, admitterObject: @escaping (Bool, MCSession?) -> Void )
    
}

public class GPGameServerAdvertiserSC : NSObject {
    
    private var service : AdvertiserService!
    private class AdvertiserService : MCNearbyServiceAdvertiser, MCNearbyServiceAdvertiserDelegate {
        
        weak var attachedTo : GPGameServerAdvertiser?
        var advertContent   : [String : String]
        
        init ( for advertiser: GPGameServerAdvertiser, advertContent: [String : String] = [:] ) {
            self.attachedTo    = advertiser
            self.advertContent = advertContent
            
            super.init (
                peer          : advertiser.advertisingFor, 
                discoveryInfo : advertContent, 
                serviceType   : self.attachedTo?.serviceType ?? ""
            )
        }
        
        func advertiser ( _ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void ) {
            attachedTo?.receivedAdmissionRequest(from: peerID, withContext: context, admitterObject: invitationHandler)
        }
        
        func advertiser ( _ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: any Error ) {
            attachedTo?.unableToAdvertise(error: error)
        }
        
    }
    
    public let serviceType    : String
    public let advertisingFor : MCPeerID
    public var advertContent  : [String : String]
    
    public init ( serves target: MCPeerID, serviceType: String, withInitialCampaignOf initContent: [String : String] = [:] ) {
        self.serviceType    = serviceType
        self.advertisingFor = target
        self.advertContent  = initContent
        
        super.init()
    }
    
    public final func loadAdvertContent ( _ content: [String : String] ) -> Self {
        self.advertContent = content
        return self
    }
    
    /// Removes the old advertservice, and replaces it with a new one
    public final func wake ( _ instance: GPGameServerAdvertiser ) {
        self.service?.stopAdvertisingPeer()
        self.service = AdvertiserService( for: instance )
        self.service?.startAdvertisingPeer()
    }
    
}
