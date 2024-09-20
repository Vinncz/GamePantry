import MultipeerConnectivity

public protocol GPGameServerNetworkManager : GPNetworkManager {
    
    var advertiserService : GPGameServerAdvertiser { get }
    
    init (  )
    
}
