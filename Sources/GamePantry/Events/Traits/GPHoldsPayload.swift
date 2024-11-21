public protocol GPHoldsPayload {
    
    /// Additional data which supplements the thing being sent.
    var payload                : [String: Any] { get set }
    
    /// Valid keys which are used to access the payload.
    associatedtype PayloadKeys : CaseIterable
    
    /// Retrieves the value for a given key in the payload.
    func value ( for key: PayloadKeys ) -> Any?
    
}
