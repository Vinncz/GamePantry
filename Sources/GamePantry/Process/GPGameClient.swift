import Foundation

public protocol GPGameClient : NSObject {
    
    var networkManager : GPGameClientNetworkManager { get set }
    var gameStorage    : GPGameTemporaryStorage { get set }
    
}
