import MultipeerConnectivity

public struct GPGameServerDiscoveryReport : Hashable {
    
    public let serverId         : MCPeerID
    public let discoveryContext : [String: String]
    
    public init ( serverId: MCPeerID, discoveryContext: [String: String] ) {
        self.serverId         = serverId
        self.discoveryContext = discoveryContext
    }
    
}
