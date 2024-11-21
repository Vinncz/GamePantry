public enum GPError : Error {
    
    case unableToBrowse ( _ description: String )
    case unableToAdvertise ( _ description: String )
    case unableToJoin ( _ description: String )
    case unableToStart ( _ description: String )
    case unableToPair ( _ description: String )
    case unableToStop ( _ description: String )
    
}
