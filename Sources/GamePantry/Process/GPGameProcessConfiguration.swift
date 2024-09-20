import Foundation

/// An immutable configuration object, which is used by GPGameProcess, 
/// to define both its GPGameServer and GPGameClient behavior.
public struct GPGameProcessConfiguration {
    
    /// A boolean value which determines whether GPGameProcess 
    /// should be started in debug mode.
    public let debugEnabled : Bool
    
    /// The name of the game being played.
    public let gameName     : String
    
    /// The version of the game being played.
    public let gameVersion  : String
    
    public init ( debugEnabled: Bool, gameName: String, gameVersion: String ) {
        self.debugEnabled = debugEnabled
        self.gameName     = gameName
        self.gameVersion  = gameVersion
    }
    
}
