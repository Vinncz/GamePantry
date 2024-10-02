import Combine

open class GPEventRouter {
    
    private var subjects     : [ObjectIdentifier: Any]         = [:]
    private var cancellables : Set<AnyCancellable>             = [ ]
    
    public init () {}
    
}

extension GPEventRouter {
    
    public func registerSubject <T: GPEvent, S: Subject> ( for eventType: T.Type, _ subject: S ) -> Bool where S.Output == T, S.Failure == Never {
        guard self.subject(for: eventType) as GPAnySubject<T, Never>? == nil else { return false }
        
        let key        = generateKey(for: eventType)
        let anySubject = GPAnySubject(subject)
        
        self.subjects[key] = anySubject
        return true
    }
    
    public func subject <T: GPEvent> ( for eventType: T.Type ) -> GPAnySubject<T, Never>? {
        let key: ObjectIdentifier = generateKey(for: eventType)
        guard let subject = subjects[key] as? GPAnySubject<T, Never> else { 
            return nil 
        }
        
        return subject
    }
    
}

extension GPEventRouter {
    
    public func registerPublisher <T: GPEvent, P: Publisher> ( for eventType: T.Type, _ publisher: P, _ applyOperators: (AnyPublisher<T, P.Failure>) -> AnyPublisher<T, P.Failure> ) -> AnyCancellable? where P.Output == T, P.Failure == Never {        
        let modifiedPublisher = applyOperators(publisher.eraseToAnyPublisher())
        
        if let existingSubject = subject(for: eventType) {
            return modifiedPublisher.sink { value in
                existingSubject.send(value)
            }
        }
        
        if registerSubject ( for: eventType, PassthroughSubject<T, Never>() ) {
            return modifiedPublisher.sink { value in
                self.subject(for: eventType)?.send(value)
            }
        }
        
        return nil
    }
    
}

extension GPEventRouter {
    
    public func route <T: GPEvent> ( _ event: T ) -> Bool {
        let key: ObjectIdentifier = generateKey(for: T.self)
        guard let subject = self.subjects[key] as? GPAnySubject<T, Never> else { 
            return false
        }
        
        subject.send(event)
        return true
    }
    
}

extension GPEventRouter {
    
    private func generateKey <T: GPEvent> ( for eventType: T.Type ) -> ObjectIdentifier {
        return ObjectIdentifier(eventType)
    }
    
    public func forceRegisterSubject <T: GPEvent, S: Subject> ( for eventType: T.Type, _ subject: S ) -> Bool where S.Output == T, S.Failure == Never {
        let key: ObjectIdentifier = generateKey(for: eventType)
        
        if self.subject(for: eventType) != nil {
            self.subjects[key] = GPAnySubject(subject)
            return true
        }
        
        self.subjects[key] = GPAnySubject(subject)
        return false
    }
    
    public func stopRouting <T: GPEvent> ( _ eventType: [T.Type] ) {
        eventType.forEach { type in
            let key: ObjectIdentifier = generateKey(for: type)
            self.subjects.removeValue(forKey: key)
        }
    }
    
    public func stopRouting ( _ eventType: [ObjectIdentifier] ) {
        eventType.forEach { key in
            self.subjects.removeValue(forKey: key)
        }
    }
    
    public func allKeys () -> [ObjectIdentifier] {
        return Array(self.subjects.keys)
    }
    
}
