import Foundation

public protocol GPGameClient : NSObject {
    
    var networkManager : GPGameClientNetworkManager { get set }
    var localStorage   : GPGameTemporaryStorage { get set }
    
}
