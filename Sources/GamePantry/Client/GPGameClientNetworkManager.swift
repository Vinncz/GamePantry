import MultipeerConnectivity

public protocol GPGameClientNetworkManager : GPNetworkManager, GPRespondsToEvents {
    
    var browser : GPGameClientBrowser { get }
        
}
