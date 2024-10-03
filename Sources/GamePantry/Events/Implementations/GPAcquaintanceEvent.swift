public struct GPAcquaintanceEvent : GPEvent {
    
    public var purpose : String
    public var time    : Date
    public var payload : [String: Any]

    public init ( _ payload: [String: Any] ) {
        self.purpose = "An event which indicates that the state of one's acquaintance has changed"
        self.time    = .now
        self.payload = payload
    }
    
}

extension GPAcquaintanceEvent : GPEasilyReadableEventPayloadKeys {
    
    public enum PayloadKeys : String, CaseIterable {
        case subject           = "subject",
             acquaintanceState = "acquaintanceState",
             updatedAt         = "updatedAt"
    }
    
    public func value ( for key: PayloadKeys ) -> Any {
        return self.payload[key.rawValue]!
    }
    
}

extension GPAcquaintanceEvent : GPRepresentableAsData {
    
    public func representedAsData () -> Data {
        return dataFrom {
            PayloadKeys.allCases.reduce(into: [String: String]()) { (result, key) in
                result[key.rawValue] = self.payload[key.rawValue] as? String ?? ""
            }
        } ?? Data()
    }
    
}
