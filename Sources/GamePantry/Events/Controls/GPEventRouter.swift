import Combine

/// The base class which can route events to parts of the application.
/// 
/// # Overview
/// Use the ``GPEventRouter`` object to open channels for events, subscribe to them, and route events to be received by subscribers.
open class GPEventRouter {
    
    private var subjects : [ObjectIdentifier: Any] = [:]
    
    public init () { }
    
}

extension GPEventRouter {
    
    /// Opens a channel for a specific event type. Returns `true` if the channel was successfully opened, `false` otherwise. Should the channel already be open, this method will return `false`.
    public func openChannel ( for eventType: GPEvent.Type ) -> Bool {
        guard self.subscribe(to: eventType) as GPAnySubject<GPEvent, Never>? == nil else { return false }
        
        let key        = generateKey(for: eventType)
        let anySubject = GPAnySubject(PassthroughSubject<GPEvent, Never>())
        
        self.subjects[key] = anySubject
        return true
    }
    
    /// Subscribes to a specific event type. Returns `nil` if the channel for the event type is not open.
    public func subscribe ( to eventType: GPEvent.Type ) -> GPAnySubject<GPEvent, Never>? {
        let key: ObjectIdentifier = generateKey(for: eventType)
        guard let subject = subjects[key] as? GPAnySubject<GPEvent, Never> else { 
            return nil 
        }
        
        return subject
    }
    
}

extension GPEventRouter {
    
    /// Routes an event to the subscribers of the event type. Returns `true` if the event was successfully routed, `false` otherwise.
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
    
    /// Generates a key for the event type.
    private func generateKey ( for eventType: GPEvent.Type ) -> ObjectIdentifier {
        let key = ObjectIdentifier(eventType)
        return key
    }
    
    /// Forces the opening of a channel for a specific event type. Returns `true` if a channel was forcefully opened (initially closed), otherwise will return `false`.
    public func forceOpenChannel ( for eventType: GPEvent.Type ) -> Bool {
        let key: ObjectIdentifier = generateKey(for: eventType)
        
        if self.subscribe(to: eventType) != nil {
            self.subjects[key] = GPAnySubject(PassthroughSubject<GPEvent, Never>())
            return true
        }
        
        self.subjects[key] = GPAnySubject(PassthroughSubject<GPEvent, Never>())
        return false
    }
    
    /// Closes the channel for the given event type.
    public func stopRouting ( _ eventType: [ObjectIdentifier] ) {
        eventType.forEach { key in
            self.subjects.removeValue(forKey: key)
        }
    }
    
    /// Lists all the keys of the event router.
    public func allKeys () -> [ObjectIdentifier] {
        return Array(self.subjects.keys)
    }
    
}
