import MultipeerConnectivity

public protocol GPGameServer : NSObject, ObservableObject {
    
    var networkManager : GPGameServerNetworkManager            { get set }
    var clientsStorage : [ MCPeerID : any GPGameTemporaryStorage ] { get set }
    
}
