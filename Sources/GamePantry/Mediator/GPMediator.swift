import Foundation

public protocol GPMediator {
    
    var mediated : [GPMediated] { get }
    
    
    func findMediated ( byName name: String ) -> GPMediated?
    
    func findMediated ( byType type: GPMediatedType ) -> [GPMediated]
    
    
    func approve ( _ mediateRequest: @escaping () -> GPMediated )
    
    
    func mediate ( whom: [GPMediated], _ code: @escaping (any GPMediated) -> Void )
    
}
