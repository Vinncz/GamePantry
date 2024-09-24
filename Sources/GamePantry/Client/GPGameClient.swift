import Foundation

public protocol GPGameClient : NSObject, GPHoldsEvents, GPRespondsToEvents {
    
    var networkManager : GPGameClientNetworkManager { get set }
    var localStorage   : GPGameTemporaryStorage { get set }
    
}
