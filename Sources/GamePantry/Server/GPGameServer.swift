import MultipeerConnectivity

public protocol GPGameServer : NSObject, GPHoldsEvents, GPRespondsToEvents, GPMediator, GPMediated {
    
    var networkManager : GPGameServerNetworkManager { get set }
    var clientsStorage : [ MCPeerID : GPGameTemporaryStorage ] { get set }
    
}
