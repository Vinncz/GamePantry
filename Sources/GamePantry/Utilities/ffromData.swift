/// Converts a Data object to a dictionary.
/// 
/// - Parameter data: A Data object.
/// - Returns: A dictionary of strings.
public func fromData ( _ data: Data ) -> [String: Any]? {
    
    return try? JSONSerialization.jsonObject (
        with: data,
        options: .fragmentsAllowed
    ) as? [String: Any]
    
}
