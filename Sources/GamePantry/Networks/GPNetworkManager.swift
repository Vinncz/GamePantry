import MultipeerConnectivity

public protocol GPNetworkManager {
    
    var eventListener : GPGameEventListener { get }
    var eventBroadcaster : GPGameEventBroadcaster { get }
    
}
