import Combine

open class GPEventRouter {
    
    private var subjects     : [ ObjectIdentifier: Any ] = [:]
    private var cancellables : Set<AnyCancellable>       = [ ]
    
    public init () {}
    
}

extension GPEventRouter {
    
    public func registerSubject <T: GPEvent, S: Subject> ( for eventType: T.Type, subject: S ) -> Bool where S.Output == T, S.Failure == Never {
        guard self.subject(for: eventType) as GPAnySubject<T, Never>? == nil else { return false }
        
        let key        = ObjectIdentifier(eventType)
        let anySubject = GPAnySubject(subject)
        
        self.subjects[key] = anySubject
        return true
    }
    
    public func subject <T: GPEvent> ( for eventType: T.Type ) -> GPAnySubject<T, Never>? {
        let key: ObjectIdentifier = ObjectIdentifier(eventType)
        guard let subject = subjects[key] as? GPAnySubject<T, Never> else { 
            return nil 
        }
        
        return subject
    }
    
}

extension GPEventRouter {
    
    public func registerPublisher <T: GPEvent, P: Publisher> ( for eventType: T.Type, publisher: P, _ applyOperators: (AnyPublisher<T, P.Failure>) -> AnyPublisher<T, P.Failure> ) -> AnyCancellable? where P.Output == T, P.Failure == Never {        
        let modifiedPublisher = applyOperators(publisher.eraseToAnyPublisher())
        
        if let existingSubject = subject(for: eventType) {
            return modifiedPublisher.sink { value in
                existingSubject.send(value)
            }
        }
        
        if registerSubject ( for: eventType, subject: PassthroughSubject<T, Never>() ) {
            return modifiedPublisher.sink { value in
                self.subject(for: eventType)?.send(value)
            }
        }
        
        return nil
    }
    
}

extension GPEventRouter {
    
    public func route <T: GPEvent> ( _ event: T ) -> Bool {
        let key: ObjectIdentifier = ObjectIdentifier( T.self )
        guard let subject = self.subjects[key] as? GPAnySubject<T, Never> else { 
            return false
        }
        
        subject.send(event)
        return true
    }
    
}

extension GPEventRouter {
    
    public func stopRouting <T: GPEvent> ( _ eventType: T.Type ) {
        let key: ObjectIdentifier = ObjectIdentifier(eventType)
        self.subjects.removeValue(forKey: key)
    }
    
    public func findSubject <T: GPEvent> ( _ eventType: T.Type ) -> GPAnySubject<T, Error>? {
        let key: ObjectIdentifier = ObjectIdentifier(eventType)
        guard let subject = self.subjects[key] as? GPAnySubject<T, Error> else { 
            return nil 
        }
        
        return subject
    }
    
}
