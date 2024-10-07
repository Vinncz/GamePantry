public protocol GPHoldsPayload {
    
    var payload                : [String: Any] { get set }
    
    associatedtype PayloadKeys : CaseIterable
    
    func value ( for key: PayloadKeys ) -> Any?
    
}
