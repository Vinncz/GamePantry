import MultipeerConnectivity

public protocol GPGameClientNetworkManager : GPNetworkManager {
    
    var browser : GPGameClientBrowser { get }
    
}
