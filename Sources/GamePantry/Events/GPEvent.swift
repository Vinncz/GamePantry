public protocol GPEvent {
    
    var id             : String { get }
    
    var purpose        : String { get }
    
    var instanciatedOn : Date   { get }
    
}
