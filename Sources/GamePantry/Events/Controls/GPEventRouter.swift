import Combine

open class GPEventRouter {
    
    private var subjects : [ ObjectIdentifier: Any ] = [:]
    
    public init () {}
    
}

extension GPEventRouter {
    
    public func registerSubject <T: GPEvent, S: Subject> ( for eventType: T.Type, subject: S ) where S.Output == T {
        let key        = ObjectIdentifier(eventType)
        let anySubject = GPAnySubject(subject)
        
        self.subjects   [key] = anySubject
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
}
