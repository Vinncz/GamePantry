import Foundation

public protocol GPEvent {
    
    var purpose : String { get }

    var time    : Date { get }
    
    var payload : [ String : Any ]? { get }
    
}
