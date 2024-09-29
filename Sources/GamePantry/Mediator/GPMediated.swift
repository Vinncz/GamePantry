import Foundation

@available(*, deprecated)
public protocol GPMediated {
    
    var medID        : String { get }
    
    var mediatedType : GPMediatedType { get }
    
    var mediator     : GPMediator? { get set }
    
    func register ( with mediator: GPMediator ) -> () -> GPMediated
    
}
