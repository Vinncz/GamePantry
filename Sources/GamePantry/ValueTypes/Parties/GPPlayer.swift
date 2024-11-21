import MultipeerConnectivity

/// Represents a player in a game.
public protocol GPPlayer : Equatable, Hashable, AnyObject {
    
    /// The address of the player, using which you can send things over the network to them.
    var playerAddress         : MCPeerID { get }
    
    /// The display name of the player.
    var playerDisplayName     : String { get }
    
    /// The state of the player's connection.
    var playerConnectionState : GPPlayerState { get }
    
    /// The metadata of the player.
    var playerMetadata        : [String: String]? { get set }
    
}

extension GPPlayer {
    
    /// Reads a metadata value from the player's metadata.
    public func read ( metadataKey: String ) -> String? {
        return playerMetadata?[metadataKey]
    }
    
    /// Writes a metadata value to the player's metadata.
    public func write ( metadataKey: String, metadataValue: String ) {
        playerMetadata?[metadataKey] = metadataValue
    }
    
    /// Removes a metadata value from the player's metadata.
    public func remove ( metadataKey: String ) {
        playerMetadata?.removeValue(forKey: metadataKey)
    }
    
    /// Returns a string representation of the player.
    public func toString () -> String {
        return "\(playerDisplayName)-(\(playerAddress.displayName))"
    }
    
}


extension GPPlayer {
    
    public static func == ( lhs: any GPPlayer, rhs: any GPPlayer ) -> Bool {
        return lhs.playerAddress == rhs.playerAddress
    }
    
}

/// Represents the state of a player's connection.
public typealias GPPlayerState = MCSessionState
