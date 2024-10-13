import Foundation

public protocol GPGameClient : NSObject {
    
    var networkManager : any GPGameClientNetworkManager { get set }
    var localStorage   : any GPGameTemporaryStorage     { get set }
    
}
