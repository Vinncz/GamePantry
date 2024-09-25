import MultipeerConnectivity

public protocol GPGameServerNetworkManager : GPNetworkManager, GPRespondsToEvents {
    
    var advertiserService : GPGameServerAdvertiser { get }
    
}
