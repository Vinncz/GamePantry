import Combine

public class GPAnySubject <Output, Failure: Error> : Subject {
    
    private let _forwardingOutputClosure       : ( Output                          ) -> Void
    private let _forwardingCompletionClosure   : ( Subscribers.Completion<Failure> ) -> Void
    private let _forwardingSubscriptionClosure : ( Subscription                    ) -> Void
    private let _forwardingSubscriberClosure   : ( AnySubscriber<Output, Failure>  ) -> Void
    
    public init <S: Subject> (_ subject: S) where S.Output == Output, S.Failure == Failure {
        _forwardingOutputClosure = { value in
            subject.send(value)
        }
        
        _forwardingCompletionClosure = { completion in
            subject.send(completion: completion)
        }
        
        _forwardingSubscriptionClosure = { subscription in
            subject.send(subscription: subscription)
        }
        
        _forwardingSubscriberClosure = { subscriber in
            subject.receive(subscriber: subscriber)
        }
    }
    
    public func send ( _ value: Output ) {
        _forwardingOutputClosure(value)
    }
    
    public func send ( completion: Subscribers.Completion<Failure> ) {
        _forwardingCompletionClosure(completion)
    }
    
    public func send ( subscription: Subscription ) {
        _forwardingSubscriptionClosure(subscription)
    }
    
    public func receive <S: Subscriber> ( subscriber: S ) where Failure == S.Failure, Output == S.Input {
        _forwardingSubscriberClosure(AnySubscriber(subscriber))
    }
    
    public func eraseToAnyPublisher () -> AnyPublisher<Output, Failure> {
        AnyPublisher(self)
    }
    
}
