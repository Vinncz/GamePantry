public struct GPGameProcessConfiguration : Sendable {
    
    public let debugEnabled   : Bool
    public let gameName       : String
    public let gameVersion    : String
    public let serviceType    : String
    public let timeout        : TimeInterval
    public let minPlayerCount : Int
    public let maxPlayerCount : Int
    public let commLimit      : Int
    
    public init ( debugEnabled: Bool, gameName: String, gameVersion: String, serviceType: String, timeout: TimeInterval = 10, minPlayerCount: Int = 2, maxPlayerCount: Int = 7, commLimit: Int = .max ) {
        guard maxPlayerCount <= 7 else {
            fatalError("Max player count must be less than or equal to 7")
        }
        
        self.debugEnabled   = debugEnabled
        self.gameName       = gameName
        self.gameVersion    = gameVersion
        self.serviceType    = serviceType
        self.timeout        = timeout
        self.minPlayerCount = minPlayerCount
        self.maxPlayerCount = maxPlayerCount
        self.commLimit      = commLimit
    }
    
}
