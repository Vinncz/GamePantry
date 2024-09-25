import Foundation

open class GPMediator {
    
    var mediated : [GPMediated] = []
    
    
    func findMediated ( byName name: String ) -> GPMediated? {
        return self.mediated.first { $0.medID == name }
    }
    
    func findMediated ( byType type: GPMediatedType ) -> [GPMediated] {
        return self.mediated.filter { $0.mediatedType == type }
    }
    
    
    func approve ( _ mediateRequest: @escaping () -> GPMediated ) {
        self.mediated.append(mediateRequest())
    }
    
    
    func mediate ( whom: [GPMediated], _ code: @escaping (any GPMediated) -> Void ) {
        whom.forEach { code($0) }
    }
    
}
