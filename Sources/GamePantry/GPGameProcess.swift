@_exported import Combine
@_exported import Foundation
@_exported import MultipeerConnectivity

public protocol GPGameProcess {
    
    var config   : GPGameProcessConfiguration { get }
    var client   : any GPGameClient { get }
    var server   : any GPGameServer { get }
        
}
