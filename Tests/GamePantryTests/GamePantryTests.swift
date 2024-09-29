import Testing
import Combine
import GamePantry
import os

struct GamePantryTests {
    
    @Test func eventRouterRoutingTest () async throws {
        
        let router = GPEventRouter()
        
        class TestEvent: GPEvent {
            var purpose: String
            
            var time: Date
            
            var payload: [String : Any]?
            
            init () {
                self.payload = nil
                self.purpose = "Test"
                self.time = .now
            }
        }
        
        class AnotherTestEvent: GPEvent {
            var purpose: String
            
            var time: Date
            
            var payload: [String : Any]?
            
            init () {
                self.payload = nil
                self.purpose = "AnotherTest"
                self.time = .now
            }
        }
        
        let subject = PassthroughSubject<TestEvent, Never>()
        router.registerSubject(for: TestEvent.self, subject: subject)
        
        let anotherSubject = PassthroughSubject<AnotherTestEvent, Never>()
        router.registerSubject(for: AnotherTestEvent.self, subject: anotherSubject)
        
        let subscription = router.subject(for: AnotherTestEvent.self)?.sink { event in
            #expect(type(of: event) == AnotherTestEvent.self, "Mismatched event type")
            #expect(event.purpose == "AnotherTest")
            
            print("received event: \(event)")
        }
        
        let isRouteSuccessful = router.route(AnotherTestEvent())
        #expect(isRouteSuccessful == true)
        
        #expect(router.route(TestEvent()) == true)

        defer {
            subscription?.cancel()
            
        }
    }
}
