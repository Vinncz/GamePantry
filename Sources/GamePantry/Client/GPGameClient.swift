import Foundation

public protocol GPGameClient : NSObject, ObservableObject {
    
    var networkManager : GPGameClientNetworkManager { get set }
    var localStorage   : any GPGameTemporaryStorage { get set }
    
}
