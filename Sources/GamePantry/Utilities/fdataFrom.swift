/// Converts a dictionary to a JSON data object.
/// 
/// - Parameter transformer: A closure that returns a dictionary of strings.
/// - Returns: A JSON data object.
public func dataFrom ( transformer: () -> [String: String] ) -> Data? {
    
    let mappedData = transformer()
    
    return try? JSONSerialization.data (
        withJSONObject : mappedData
    )
    
}
