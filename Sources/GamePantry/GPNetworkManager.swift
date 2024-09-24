import MultipeerConnectivity

public protocol GPNetworkManager {
    
    var acquaintancedParties : [MCPeerID : MCSessionState] { get set }
    
    var blacklistedParties   : [MCPeerID : MCSessionState] { get set }
    
    var gameProcessConfig    : GPGameProcessConfiguration { get }
    
    var eventListener        : GPGameEventListener { get }
    
    var eventBroadcaster     : GPGameEventBroadcaster { get }
    
    func blacklist ( _ peerID: MCPeerID )
            
}

extension GPNetworkManager {
    public var whitelistedParties   : [MCPeerID : MCSessionState] {
        acquaintancedParties.filter { acquaintance, _ in
            !blacklistedParties.contains { blacklisted, _ in
                acquaintance == blacklisted
            }
        }
    }
}
