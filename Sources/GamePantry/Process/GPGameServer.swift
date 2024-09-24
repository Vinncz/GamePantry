import MultipeerConnectivity

public protocol GPGameServer : NSObject {
    
    var networkManager : GPGameServerNetworkManager { get set }
    var clientsStorage : [ MCPeerID : GPGameTemporaryStorage ] { get set }
    
}
