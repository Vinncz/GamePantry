import Combine

open class GPEventRouter {
    
    private var subjects : [ObjectIdentifier: Any] = [:]
    
    public init () { }
    
}

extension GPEventRouter {
    
    public func openChannel ( for eventType: GPEvent.Type ) -> Bool {
        guard self.subscribe(to: eventType) as GPAnySubject<GPEvent, Never>? == nil else { return false }
        
        let key        = generateKey(for: eventType)
        let anySubject = GPAnySubject(PassthroughSubject<GPEvent, Never>())
        
        self.subjects[key] = anySubject
        return true
    }
    
    public func subscribe ( to eventType: GPEvent.Type ) -> GPAnySubject<GPEvent, Never>? {
        let key: ObjectIdentifier = generateKey(for: eventType)
        guard let subject = subjects[key] as? GPAnySubject<GPEvent, Never> else { 
            return nil 
        }
        
        return subject
    }
    
}

extension GPEventRouter {
    
    public func route ( _ event: GPEvent ) -> Bool {
        let key: ObjectIdentifier = generateKey(for: type(of: event))
        guard let subject = self.subjects[key] as? GPAnySubject<GPEvent, Never> else { 
            return false
        }
        subject.send(event)
        return true
    }
    
}

extension GPEventRouter {
    
    private func generateKey ( for eventType: GPEvent.Type ) -> ObjectIdentifier {
        let key = ObjectIdentifier(eventType)
        return key
    }
    
    public func forceOpenChannel ( for eventType: GPEvent.Type ) -> Bool {
        let key: ObjectIdentifier = generateKey(for: eventType)
        
        if self.subscribe(to: eventType) != nil {
            self.subjects[key] = GPAnySubject(PassthroughSubject<GPEvent, Never>())
            return true
        }
        
        self.subjects[key] = GPAnySubject(PassthroughSubject<GPEvent, Never>())
        return false
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
