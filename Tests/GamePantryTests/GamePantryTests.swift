import Testing
import Combine
import GamePantry
import os

struct GamePantryTests {
    
    @Test func eventRouterRoutingTest () async throws {
        
        let router = GPEventRouter()
        var subscription = Set<AnyCancellable>()
        
        let blacklistedEvent = GPBlacklistedEvent (
            who: MCPeerID(displayName: "Test"),
            reason: "Test",
            payload: nil
        )
        let acquaintanceEvent = GPAcquaintanceEvent (
            who: MCPeerID(displayName: "Test"),
            newState: .connected,
            payload: nil
        )
        
        let blacklistedSubject = PassthroughSubject<GPBlacklistedEvent, Never>()
        router.registerSubject(for: GPBlacklistedEvent.self, subject: blacklistedSubject)
        
        let subject = router.subject(for: GPBlacklistedEvent.self)?.sink { event in
            print("received blacklisted event: \(event)")
        }
        
        router.route(blacklistedEvent)
        blacklistedSubject.send(blacklistedEvent)
                
        let acquaintancePublisher = Just(acquaintanceEvent)
        subscription.insert (
            router.registerPublisher(for: GPAcquaintanceEvent.self, publisher: acquaintancePublisher) { modifyThePublisherHere in
                modifyThePublisherHere
                    .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
                    .eraseToAnyPublisher()
            }!
        )
        
        let subject2 = router.subject(for: GPAcquaintanceEvent.self)?.sink { event in
            print("Received event: \(event.purpose) on: \(event.time)")
        }.store(in: &subscription)
        
        for _ in 1...10 {
            #expect(router.route(acquaintanceEvent) == true)
        }
        
//        #expect(subscription.isEmpty, "subscription should be empty")
    }
}
