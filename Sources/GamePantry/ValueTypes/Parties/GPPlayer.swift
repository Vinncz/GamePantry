import MultipeerConnectivity

/// Represents a player in a game.
public protocol GPPlayer : Equatable, Hashable, AnyObject {
    
    /// The address of the player, using which you can send things over the network to them.
    var address         : MCPeerID { get set }
    
    /// The display name of the player.
    var name            : String { get set }
    
    /// The state of the player's connection.
    var connectionState : GPPlayerState { get set }
    
    /// The metadata of the player.
    var metadata        : [String: String]? { get set }
    
}

extension GPPlayer {
    
    /// The unique identifier of the player, fetched from the player's address.
    var id : String {
        address.displayName
    }
    
}

extension GPPlayer {
    
    /// Reads a metadata value from the player's metadata.
    public func read ( metadataKey: String ) -> String? {
        return metadata?[metadataKey]
    }
    
    /// Writes a metadata value to the player's metadata.
    public func write ( metadataKey: String, metadataValue: String ) {
        metadata?[metadataKey] = metadataValue
    }
    
    /// Removes a metadata value from the player's metadata.
    public func remove ( metadataKey: String ) {
        metadata?.removeValue(forKey: metadataKey)
    }
    
    /// Returns a string representation of the player.
    public func toString () -> String {
        return "\(name)-(\(address.displayName))"
    }
    
}


extension GPPlayer {
    
    public static func == ( lhs: any GPPlayer, rhs: any GPPlayer ) -> Bool {
        return lhs.address == rhs.address
    }
    
}

extension GPPlayer {
    
    public func hash ( into hasher: inout Hasher ) {
        hasher.combine(address)
    }
    
}

/// Represents the state of a player's connection.
public typealias GPPlayerState = MCSessionState
