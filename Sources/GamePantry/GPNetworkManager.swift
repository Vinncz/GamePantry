import MultipeerConnectivity

public protocol GPNetworkManager {

    var gameProcessConfig    : GPGameProcessConfiguration { get }
    
    var eventListener        : GPGameEventListener { get }
    
    var eventBroadcaster     : GPGameEventBroadcaster { get }
            
}
