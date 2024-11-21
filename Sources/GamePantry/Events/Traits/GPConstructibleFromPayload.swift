/// The base protocol for objects which can be constructed from a payload.
public protocol GPConstructibleFromPayload {
    
    static func construct ( from payload: [String: Any] ) -> Self?
    
}
