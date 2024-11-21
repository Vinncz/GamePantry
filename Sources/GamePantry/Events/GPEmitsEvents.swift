/// The base protocol for types which can emit events.
public protocol GPEmitsEvents {
    
    func emit ( _ event: GPEvent ) -> Bool
    
}
