public protocol GPEasilyReadableEventPayloadKeys {
    
    associatedtype PayloadKeys : CaseIterable
    
    func value ( for: PayloadKeys ) -> Any
    
}
