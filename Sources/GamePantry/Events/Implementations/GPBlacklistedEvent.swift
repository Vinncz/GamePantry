public struct GPBlacklistedEvent : GPEvent {
    
    public let purpose : String
    public let time    : Date
    public let payload : [String: Any]
    
    public init ( _ payload: [String: Any] ) {
        self.purpose = "An event that marks a peer as blacklisted"
        self.time    = .now
        self.payload = payload
    }
    
}

extension GPBlacklistedEvent : GPEasilyReadableEventPayloadKeys {
    
    public enum PayloadKeys : String, CaseIterable {
        case subject       = "subject",
             reason        = "causeOfBlacklist",
             effectiveTime = "effectiveTime"
    }
    
    public func value ( for key: PayloadKeys ) -> Any {
        return self.payload[key.rawValue]!
    }
    
}

extension GPBlacklistedEvent : GPRepresentableAsData {
    
    public func representedAsData () -> Data {
        return dataFrom {
            PayloadKeys.allCases.reduce(into: [String: String]()) { (result, key) in
                result[key.rawValue] = self.payload[key.rawValue] as? String ?? ""
            }
        } ?? Data()
    }
    
}
