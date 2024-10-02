public protocol GPRepresentableAsData {
    
    func representedAsData () -> Data
    
}

public func dataFrom ( transformer: () -> [String: String] ) -> Data? {
    
    let mappedData = transformer()
    
    return try? JSONSerialization.data (
        withJSONObject : mappedData
    )
    
}
