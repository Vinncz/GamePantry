import Combine

public protocol GPHandlesEvents {
    
    var subscriptions : Set<AnyCancellable> { get set }
    
    func placeSubscription ( on eventType: GPEvent.Type )
    
}
