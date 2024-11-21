extension Data {
    
    /// A chain-up method. Tries to convert the data to a string.
    public func toString ( encoder: String.Encoding = .utf8 ) -> String? {
        String(data: self, encoding: encoder)
    }
    
}
