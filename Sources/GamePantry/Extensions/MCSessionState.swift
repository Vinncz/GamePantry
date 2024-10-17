import MultipeerConnectivity

extension MCSessionState {
    
    public func toString () -> String {
        switch self {
            case .connected:
                return "Connected"
            case .connecting:
                return "Connecting"
            case .notConnected:
                return "Not Connected"
            default:
                return "Unknown"
        }
    }
    
}
