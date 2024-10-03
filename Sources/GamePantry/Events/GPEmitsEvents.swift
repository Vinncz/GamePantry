public protocol GPEmitsEvents {
    
    var eventRouter: GPEventRouter? { get set }
    
    func emit ( _ event: GPEvent ) -> Bool
    
}
