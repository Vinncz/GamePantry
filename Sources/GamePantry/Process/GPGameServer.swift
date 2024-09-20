import MultipeerConnectivity

public protocol GPGameServer : NSObject {
    
    var networkManager : GPGameServerNetworkManager { get }
    var clientsStorage : [ MCPeerID : GPGameTemporaryStorage ] { get set }
    
}
