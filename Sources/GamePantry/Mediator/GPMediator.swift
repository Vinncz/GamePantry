import Foundation

@available(*, deprecated)
public actor GPMediator {
    
    var mediated : [GPMediated] = []
    
    func approve ( _ mediateRequest: @escaping () -> GPMediated ) {
        self.mediated.append(mediateRequest())
    }
    
}

extension GPMediator {
    
    func mediate ( whom: [GPMediated], _ code: @escaping (any GPMediated) -> Void ) {
        whom.forEach { code($0) }
    }
    
}

extension GPMediator {
    
    func findMediated ( byName name: String ) -> GPMediated? {
        return self.mediated.first { $0.medID == name }
    }
    
    func findMediated ( byType type: GPMediatedType ) -> [GPMediated] {
        return self.mediated.filter { $0.mediatedType == type }
    }
    
}
