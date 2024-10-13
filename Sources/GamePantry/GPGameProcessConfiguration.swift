public struct GPGameProcessConfiguration : Sendable {
    
    public let debugEnabled : Bool
    public let gameName     : String
    public let gameVersion  : String
    public let serviceType  : String
    public let commLimit    : Int
    
    public init ( debugEnabled: Bool, gameName: String, gameVersion: String, serviceType: String ) {
        self.debugEnabled = debugEnabled
        self.gameName     = gameName
        self.gameVersion  = gameVersion
        self.serviceType  = serviceType
        self.commLimit    = .max
    }
    
}
