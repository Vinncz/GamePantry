@_exported import Combine
@_exported import Foundation
@_exported import MultipeerConnectivity

public protocol GPGameProcess {
    
    var config   : GPGameProcessConfiguration { get }
    var client   : GPGameClient { get }
    var server   : GPGameServer { get }
        
}
