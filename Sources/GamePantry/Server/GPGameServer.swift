import MultipeerConnectivity

public protocol GPGameServer : NSObject {
    
    var networkManager : any GPGameServerNetworkManager            { get set }
    var clientsStorage : [ MCPeerID : any GPGameTemporaryStorage ] { get set }
    
}
