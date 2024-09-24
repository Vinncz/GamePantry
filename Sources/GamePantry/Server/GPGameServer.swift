import MultipeerConnectivity

public protocol GPGameServer : NSObject, GPHoldsEvents, GPRespondsToEvents {
    
    var networkManager : GPGameServerNetworkManager { get set }
    var clientsStorage : [ MCPeerID : GPGameTemporaryStorage ] { get set }
    
}
