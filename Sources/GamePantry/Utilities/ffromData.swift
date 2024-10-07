public func fromData ( data: Data ) -> [String: Any]? {
    
    return try? JSONSerialization.jsonObject (
        with: data,
        options: .fragmentsAllowed
    ) as? [String: Any]
    
}
