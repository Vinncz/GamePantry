import Testing
import Combine
import GamePantry
import os

struct GamePantryTests {
    
    @Test func testAja () async throws {
        let abc = Abc()
    }
    
    @Test func eventRouterSubjectRegistration () async throws {
        
        let router  = GPEventRouter()
        let subject = PassthroughSubject<GPAnyEvent, Never>()
        
        
        
        // MARK: -- Phase I • A subject for an empty key
        #expect (
            router.openChannel(for: GPAnyEvent.self) == true,
            "registration must succeed"
        )
        
        #expect (
            router.openChannel(for: GPAnyEvent.self) == false,
            "overwriting an existing subject for a given event type must fail"
        )
        
        #expect (
            router.forceOpenChannel(for: GPAnyEvent.self) == true,
            "force registration will only return true when it overwrites an existing subject"
        )
        
        
        
        // MARK: -- Phase II • Different subject instance for the same key
        typealias ae = GPAcquaintanceEvent.PayloadKeys
        let acquaintanceEvent = GPAcquaintanceEvent([
            ae.subject.rawValue           : "Myself",
            ae.acquaintanceState.rawValue : "Connected",
            ae.updatedAt.rawValue         : "\(Date.now)"
        ])
        let anotherSubject = CurrentValueSubject<GPAnyEvent, Never>(GPAnyEvent(acquaintanceEvent))
        
        #expect (
            router.openChannel(for: GPAnyEvent.self) == false,
            "tried to register a subject for an event type that is already registered"
        )

        router.stopRouting(router.allKeys())
        
        #expect (
            router.openChannel(for: GPAnyEvent.self) == true,
            "after the router stopped routing, all registered subjects must be re-registered, or they'll lose their spot alongside their subscribers"
        )
        
        #expect (
            router.forceOpenChannel(for: GPAnyEvent.self) == true,
            "force registration will only return true when it overwrites an existing subject"
        )
        
        router.stopRouting(router.allKeys())
                
    }
    
    @Test func eventRouterSubjectRouteBroadcast () async throws {
        
        let router           = GPEventRouter()
        var subscription     = Set<AnyCancellable>()
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"


        
        // MARK: -- Phase I • Setting things up
        let subject = PassthroughSubject<GPAcquaintanceEvent, Never>()
        typealias ae = GPAcquaintanceEvent.PayloadKeys
        let acquaintanceEvent = GPAcquaintanceEvent([
            ae.subject.rawValue           : "Myself",
            ae.acquaintanceState.rawValue : "Connected",
            ae.updatedAt.rawValue         : "\(formatter.string(from: .now))"
        ])
        
        #expect (
            router.openChannel(for: GPAcquaintanceEvent.self) == true,
            "subject registration must succeed"
        )
        
        typealias te = GPTerminationEvent.PayloadKeys
        let terminationEvent = GPTerminationEvent([
            te.subject.rawValue           : "You",
            te.terminationReason.rawValue : "Misbehaved",
            te.effectiveTime.rawValue     : "\(formatter.string(from: .now))"
        ])
        
        #expect (
            router.openChannel(for: GPTerminationEvent.self) == true,
            "subject registration must succeed"
        )
        
        
        // MARK: -- Phase II • Subscribing to the router
        #expect (
            subscription.insert (
                router.subscribe(to: GPAcquaintanceEvent.self)!.sink { val in
                    print("received from subject typed: \(type(of: val)), as \((val as! GPAcquaintanceEvent).representedAsData().toString()!)")
                }
            ).inserted == true,
            "attaching a subscription to the subject @router must succeed"
        )
        
        #expect (
            subscription.insert (
                router.subscribe(to: GPTerminationEvent.self)!.sink { val in
                    print("received from publisher typed: \(type(of: val)), as \((val as! GPTerminationEvent).representedAsData().toString()!)")
                }
            ).inserted == true,
            "attaching subscription to the publisher @router must succeed"
        )
        
        
        
        // MARK: -- Phase III • Actually routing things
        #expect (
            router.route(terminationEvent) == true,
            "route(terminationEvent) must succeed, because a publisher has been registered for the type of GPTerminationEvent"
        )
        
        #expect (
            router.route(acquaintanceEvent) == true,
            "route(acquaintanceEvent) must succeed, because a publisher has been registered for the type of GPAcquaintanceEvent"
        )
        
        for _ in 1...1_000 {
            #expect (
                router.route(acquaintanceEvent) == true,
                "route(acquaintanceEvent) must succeed, because a publisher has been registered for the type of GPAcquaintanceEvent"
            )
            
            #expect (
                router.route(terminationEvent) == true,
                "route(terminationEvent) must succeed, because a publisher has been registered for the type of GPTerminationEvent"
            )
        }
        
    }
    
}
