public protocol GPConstructibleFromPayload {
    
    static func construct ( from payload: [String: Any] ) -> Self?
    
}
