/// Protocol for types which can be represented as `Data`.
///
/// Use this protocol for types used in storage or networking, where the type ``Data`` is usually accepted.
/// Implementation-specific `representedAsData()` needs to be written to conform to this protocol.
///
/// ```
/// struct MyType: GPRepresentableAsData {
///     var data : Whatnot
///
///     func representedAsData () -> Data {
///         return JSONEncoder().encode(self.data)
///     }
/// }
/// ```
public protocol GPRepresentableAsData {
    
    /// Converts the conforming type into `Data`.
    /// 
    /// - Returns: `Data` representation of the conforming type.
    func representedAsData () -> Data
    
}
