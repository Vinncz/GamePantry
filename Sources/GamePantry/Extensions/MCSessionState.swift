import MultipeerConnectivity

extension MCSessionState {
    
    /// A chain-up method. Returns a string representation of the state.
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
