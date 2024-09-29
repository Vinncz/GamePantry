//import Testing
//import Combine
//@testable import GamePantry
//import os
//
//struct Test {
//
//    @Test func eventRouterRoutingTest () async throws {
//        
//        let router = GPEventRouter()
//        
//        class TestEvent: GPEvent {
//            var purpose: String
//            
//            var time: Date
//            
//            var payload: [String : Any]?
//            
//            init () {
//                self.payload = nil
//                self.purpose = "Test"
//                self.time = .now
//            }
//        }
//        
//        class AnotherTestEvent: GPEvent {
//            var purpose: String
//            
//            var time: Date
//            
//            var payload: [String : Any]?
//            
//            init () {
//                self.payload = nil
//                self.purpose = "AnotherTest"
//                self.time = .now
//            }
//        }
//        
//        let log = Logger()
//        
////        let subject = PassthroughSubject<TestEvent, Never>()
////        router.registerSubject(for: TestEvent.self, subject: subject)
//        
//        let anotherSubject = CurrentValueSubject<AnotherTestEvent, Never>(AnotherTestEvent())
//        router.registerSubject(for: AnotherTestEvent.self, subject: anotherSubject)
//        
//        let subscription = router.publisher(for: TestEvent.self)?.sink { event in
//            #expect(type(of: event) == TestEvent.self, "Mismatched event type")
//            
//            #expect(event.purpose == "Testa")
//            
//            #expect(true==false)
//        }
//        
//        let isRouteSuccessful = router.route(AnotherTestEvent())
//        #expect(isRouteSuccessful == true)
//        subscription?.cancel()
//        
//    }
//
//}
