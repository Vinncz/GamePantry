import Foundation

public struct GPGameProcessConfiguration {
    
    public let debugEnabled : Bool
    public let gameName     : String
    public let gameVersion  : String
    
    public init ( debugEnabled: Bool, gameName: String, gameVersion: String ) {
        self.debugEnabled = debugEnabled
        self.gameName     = gameName
        self.gameVersion  = gameVersion
    }
    
}
