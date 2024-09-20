import Foundation

public protocol GPGameProcess {
    
    var config : GPGameProcessConfiguration { get }
    var client : GPGameClient { get }
    var server : GPGameServer? { get set }
    
    init ( config: GPGameProcessConfiguration )
    
}
