public protocol GPEmitsEvents {
    
    var eventRouter: GPEventRouter? { get set }
    
    func emit <T: GPEvent> ( _ event: T ) -> Bool
    
}
