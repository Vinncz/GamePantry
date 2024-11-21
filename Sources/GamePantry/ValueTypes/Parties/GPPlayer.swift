import MultipeerConnectivity

/// Represents a player in a game.
public protocol GPPlayer {
    
    /// The address of the player, using which you can send things over the network to them.
    var playerAddress         : MCPeerID { get }
    
    /// The display name of the player.
    var playerDisplayName     : String { get }
    
    /// The state of the player's connection.
    var playerConnectionState : GPPlayerState { get }
    
    /// The metadata of the player.
    var playerMetadata        : [String: String]? { get set }
    
}

/// Represents the state of a player's connection.
public typealias GPPlayerState = MCSessionState
