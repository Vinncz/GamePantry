public class GPTerminationEvent : GPEvent {
    
    public let purpose : String
    public let time    : Date
    public let payload : [String: Any]
    
    public init ( _ payload: [String: Any] ) {
        self.purpose = "An event that marks the termination of relationship of a game client with the server its connected to"
        self.time    = .now
        self.payload = payload
    }
    
}

extension GPTerminationEvent : GPEasilyReadableEventPayloadKeys {
    
    public enum PayloadKeys : String, CaseIterable {
        case subject           = "subject",
             terminationReason = "causeOfTermination",
             effectiveTime     = "effectiveTime"
    }
    
    public func value ( for key: PayloadKeys ) -> Any {
        return self.payload[key.rawValue]!
    }
    
}

extension GPTerminationEvent : GPRepresentableAsData {
    
    public func representedAsData () -> Data {
        return dataFrom {
            PayloadKeys.allCases.reduce(into: [String: String]()) { (result, key) in
                result[key.rawValue] = String(describing: self.payload[key.rawValue]!)
            }
        } ?? Data()
    }
    
}
