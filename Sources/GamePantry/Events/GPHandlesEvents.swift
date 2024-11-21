import Combine

/// The base protocol for types which can handle events.
public protocol GPHandlesEvents {
    
    var subscriptions : Set<AnyCancellable> { get set }
    
    func placeSubscription ( on eventType: GPEvent.Type )
    
}
