import Foundation

public protocol GPGameClient : NSObject, GPHoldsEvents, GPRespondsToEvents, GPMediator, GPMediated {
    
    var networkManager : GPGameClientNetworkManager { get set }
    var localStorage   : GPGameTemporaryStorage { get set }
    
}
