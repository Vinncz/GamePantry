import Combine

public protocol GPHandlesEvents {
    
    var subscriptions: Set<AnyCancellable> { get set }
    
    func listen <T: GPAnyEvent> ( for eventType: T.Type, publisher: AnyPublisher<T, Never> )
    
}
