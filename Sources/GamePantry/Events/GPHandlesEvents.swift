import Combine

public protocol GPHandlesEvents {
    
    var eventRouter   : GPEventRouter?      { get set }
    var subscriptions : Set<AnyCancellable> { get set }
    
    func placeSubscription ( on eventType: GPEvent.Type )
    
}
