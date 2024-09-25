import Foundation

public struct GPGameProcessConfiguration {
    
    public let debugEnabled : Bool
    public let gameName     : String
    public let gameVersion  : String
    public let serviceType  : String
    
    public init ( debugEnabled: Bool, gameName: String, gameVersion: String, serviceType: String ) {
        self.debugEnabled = debugEnabled
        self.gameName     = gameName
        self.gameVersion  = gameVersion
        self.serviceType  = serviceType
    }
    
}