import MultipeerConnectivity

public protocol GPGameClientNetworkManager : GPNetworkManager {
    
    var serverBrowser : GPGameClientBrowser { get }
    
}
