/// The convenience type for objects which does two-way communication in the network.
public protocol GPNetworkManager {

    var gameProcessConfig    : GPGameProcessConfiguration { get }
    
    var eventListener        : GPNetworkListener { get }
    
    var eventBroadcaster     : GPNetworkBroadcaster { get }
            
}
