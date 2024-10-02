extension Data {
    
    public func toString ( encoder: String.Encoding = .utf8 ) -> String? {
        String(data: self, encoding: encoder)
    }
    
}
