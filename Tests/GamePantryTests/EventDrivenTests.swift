import Testing
import Combine
import GamePantry
import os

struct EventDrivenTests {
    
    @Test func eventRouterSubjectRegistration () async throws {
        
        let router  = GPEventRouter()        
        
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
        typealias ae = GPAcquaintanceStatusUpdateEvent
        let acquaintanceEvent = GPAcquaintanceStatusUpdateEvent(
            subject: MCPeerID(displayName: "Myself"), status: .connected
        )
        
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
        let acquaintanceEvent = GPAcquaintanceStatusUpdateEvent (
            subject: MCPeerID(displayName: "Myself"), status: .connected
        )
        
        #expect (
            router.openChannel(for: GPAcquaintanceStatusUpdateEvent.self) == true,
            "subject registration must succeed"
        )
        
        typealias te = GPTerminatedEvent.PayloadKeys
        let terminationEvent = GPTerminatedEvent (
            subject: "You", reason: "Griefing"
        )
        
        #expect (
            router.openChannel(for: GPTerminatedEvent.self) == true,
            "subject registration must succeed"
        )
        
        
        // MARK: -- Phase II • Subscribing to the router
        #expect (
            subscription.insert (
                router.subscribe(to: GPAcquaintanceStatusUpdateEvent.self)!.sink { val in
                    print("received from subject typed: \(type(of: val)), as \((val as! GPAcquaintanceStatusUpdateEvent))")
                }
            ).inserted == true,
            "attaching a subscription to the subject @router must succeed"
        )
        
        #expect (
            subscription.insert (
                router.subscribe(to: GPTerminatedEvent.self)!.sink { val in
                    print("received from publisher typed: \(type(of: val)), as \((val as! GPTerminatedEvent).representedAsData().toString()!)")
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
    
    @Test func constructEventFromPayload () async throws {
        let bevent = GPBlacklistedEvent (
            subject: "You", reason: "Ugly"
        )
        
        // from client (as host) to the server
        let beventAsData = bevent.representedAsData()
        
        // server receives the event in form of Data
        let decodedData = fromData(data: beventAsData)!
        
        // GPNetworkListener should be able to reconstruct it back to the complete GPEvent from
        let reconstructedBevent = GPBlacklistedEvent.construct(from: decodedData)
        
        // Check if all attributes are correct
        #expect(
            reconstructedBevent?.subject == "You",
            "Decoded subject is different from what's expected"
        )
        #expect(
            reconstructedBevent?.reason == "Ugly",
            "Decoded reason is different from what's expected"
        )
    }
    
}
