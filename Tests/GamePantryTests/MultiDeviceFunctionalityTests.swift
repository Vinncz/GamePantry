import Testing
import GamePantry

struct MultiDeviceFunctionalityTests {
    
    @Test func discoverable () async throws {
        let backend = MockGameServer()
        let frontend = MockGameClient()
        
        let bNM = backend.networkManager as! MockGameServerNetworkManager
        let fNM = frontend.networkManager as! MockGameClientNetworkManager
        
        let bAS = bNM.advertiserService as! MockGameServerAdvertiser
        let fBw = fNM.browser as! MockGameClientBrowser
        
        bAS.startAdvertising (
            what: [
                "roomName": "Sample Room"
            ], 
            on: backend.networkManager.advertiserService
        )
        fBw.startBrowsing(frontend.networkManager.browser)
        
        for _ in 0...50_000 {
            print("just buying time")
        }
        
        #expect (
            fBw.discoveryObjects.contains { disObj in
                disObj.serverId == bNM.myself
            } == true,
            "Did not discover the backend server"
        )
    }
    
    @Test func askedToJoin () async throws {
        let backend = MockGameServer()
        let frontend = MockGameClient()
        
        let bNM = backend.networkManager as! MockGameServerNetworkManager
        let fNM = frontend.networkManager as! MockGameClientNetworkManager
        
        let bAS = bNM.advertiserService as! MockGameServerAdvertiser
        let fBw = fNM.browser as! MockGameClientBrowser
        
        bAS.startAdvertising (
            what: [
                "roomName": "Sample Room"
            ], 
            on: backend.networkManager.advertiserService
        )
        fBw.startBrowsing(frontend.networkManager.browser)
        
        for _ in 0...50_000 {
            print("just buying time")
        }
        
        if let disObj = fBw.discoveryObjects.first {
            frontend.networkManager.eventBroadcaster.approve(frontend.networkManager.browser.requestToJoin(disObj.serverId))
            
            for _ in 0...60_000 {
                print("just buying time")
            }
            
            #expect (
                backend.networkManager.advertiserService.pendingRequests.contains { penReq in
                    penReq.requestee == fNM.myself
                } == true,
                "Backend did not receive clien't request to join"
            )
        } else {
            #expect(true==false, "Did not discover the backend server")
        }
    }
    
    @Test func approvedToJoin () async throws {
        let backend = MockGameServer()
        let frontend = MockGameClient()
        
        let bNM = backend.networkManager as! MockGameServerNetworkManager
        let fNM = frontend.networkManager as! MockGameClientNetworkManager
        
        let bAS = bNM.advertiserService as! MockGameServerAdvertiser
        let fBw = fNM.browser as! MockGameClientBrowser
        
        bAS.startAdvertising (
            what: [
                "roomName": "Sample Room"
            ], 
            on: backend.networkManager.advertiserService
        )
        fBw.startBrowsing(frontend.networkManager.browser)
        
        for _ in 0...50_000 {
            print("just buying time")
        }
        
        if let disObj = fBw.discoveryObjects.first {
            frontend.networkManager.eventBroadcaster.approve(frontend.networkManager.browser.requestToJoin(disObj.serverId))
            
            for _ in 0...50_000 {
                print("just buying time")
            }
            
            if let request = backend.networkManager.advertiserService.pendingRequests.first {
                backend.networkManager.eventBroadcaster.approve(request.resolve(to: .admit))
                
                for _ in 0...60_000 {
                    print("just buying time")
                }
                
                #expect (
                    frontend.networkManager.eventBroadcaster.getPeers().contains { peer in
                        peer.displayName == bNM.myself.displayName
                    } == true,
                    "Server should be in the list of acquaintanced peers"
                )
                
                #expect (
                    backend.networkManager.eventBroadcaster.getPeers().contains { peer in
                        peer.displayName == fNM.myself.displayName
                    } == true,
                    "Client should be in the list of acquaintanced peers"
                )
                
            } else {
                #expect(true==false, "Server did not receive a request to join")
            }
        
        } else {
            #expect(true==false, "Did not discover the backend server")
        }
    }
    
}

extension MultiDeviceFunctionalityTests {
    
    static let gameProcessConfig = GamePantry.GPGameProcessConfiguration (
        debugEnabled: true, 
        gameName: "MockTest", 
        gameVersion: "0.1-test", 
        serviceType: "mock-test"
    )
    
    class MockGameClient : NSObject, GPGameClient {
        
        var networkManager : any GamePantry.GPGameClientNetworkManager
        var localStorage   : any GamePantry.GPGameTemporaryStorage
        
        override init () {
            self.networkManager = MockGameClientNetworkManager(configuration: MultiDeviceFunctionalityTests.gameProcessConfig)
            self.localStorage   = MockGameTemporaryStorage()
        }
        
    }
    
    class MockGameServer : NSObject, GPGameServer {
        
        var networkManager: any GamePantry.GPGameServerNetworkManager
        var clientsStorage: [MCPeerID : any GamePantry.GPGameTemporaryStorage]
        
        override init () {
            self.networkManager = MockGameServerNetworkManager(configuration: MultiDeviceFunctionalityTests.gameProcessConfig)
            self.clientsStorage = [:]
        }
        
    }
    
}

extension MultiDeviceFunctionalityTests {
    
    class MockGameClientNetworkManager : GPGameClientNetworkManager {
        
        var gameProcessConfig: GamePantry.GPGameProcessConfiguration
        var browser: any GamePantry.GPGameClientBrowser
        var eventListener: any GamePantry.GPNetworkListener
        var eventBroadcaster: GamePantry.GPNetworkBroadcaster
        
        let myself = MCPeerID(displayName: "MockTestClient")
        
        init ( configuration: GamePantry.GPGameProcessConfiguration ) {
            gameProcessConfig = configuration
            
            let browser = MockGameClientBrowser(serves: myself, serviceType: configuration.serviceType)
            let eventListener = MockGameEventListener()
            let eventBroadcaster = GPNetworkBroadcaster(serves: myself).pair(eventListener)
            
            self.browser = browser
            self.eventListener = eventListener
            self.eventBroadcaster = eventBroadcaster
        }
        
    }
    
    class MockGameServerNetworkManager : GPGameServerNetworkManager {
        
        var advertiserService: any GamePantry.GPGameServerAdvertiser
        var gameProcessConfig: GamePantry.GPGameProcessConfiguration
        var eventListener: any GamePantry.GPNetworkListener
        var eventBroadcaster: GamePantry.GPNetworkBroadcaster
        
        let myself = MCPeerID(displayName: "MockTestServer")
        
        init ( configuration: GamePantry.GPGameProcessConfiguration ) {
            gameProcessConfig = configuration
            
            let advertiserService = MockGameServerAdvertiser(serves: myself, serviceType: configuration.serviceType)
            let eventListener = MockGameEventListener()
            let eventBroadcaster = GPNetworkBroadcaster(serves: myself).pair(eventListener)
            
            self.advertiserService = advertiserService
            self.eventListener = eventListener
            self.eventBroadcaster = eventBroadcaster
        }
    }
    
    class MockGameClientBrowser : GPGameClientBrowser {
        
        var discoveryObjects : [GPGameServerDiscoveryReport] = []
        
        func unableToBrowse(error: any Error) {
            fatalError("Unable to browse: \(error)")
        }

        func didFindJoinableServer(_ serverId: MCPeerID, with discoveryInfo: [String : String]?) {
            discoveryObjects.append (
                GPGameServerDiscoveryReport (
                    serverId: serverId, 
                    discoveryContext: discoveryInfo ?? [:]
                )
            )
        }

        func didLoseJoinableServer(_ serverId: MCPeerID) {
            discoveryObjects.removeAll(where: { $0.serverId == serverId })
        }
        
    }
    
    class MockGameServerAdvertiser : GPGameServerAdvertiser {
                
        func unableToAdvertise(error: any Error) {
            fatalError("Unable to advertise: \(error)")
        }

        func didReceiveAdmissionRequest(from peer: MCPeerID, withContext: Data?, admitterObject: @escaping (Bool, MCSession?) -> Void) {
            self.pendingRequests.append (
                GPGameJoinRequest (
                    requestee: peer, admitterObject: admitterObject
                )
            )
        }
        
    }
    
    class MockGameEventBroadcaster : GPNetworkBroadcaster {
        
        
        
    }
    
    class MockGameEventListener : GPNetworkListener {
        
        func heardNews(of: MCPeerID, to: MCSessionState) {
            print("heard news of \(of)'s new state \(to)")
        }

        func heardData(from peer: MCPeerID, _ data: Data) {
            
        }

        func heardIncomingStreamRequest(from peer: MCPeerID, _ stream: InputStream, withContextOf context: String) {
            
        }

        func heardIncomingResourceTransfer(from peer: MCPeerID, withContextOf context: String, withProgress progress: Progress) {
            
        }

        func heardCompletionOfResourceTransfer(context: String, sender: MCPeerID, savedAt: URL?, withAccompanyingErrorOf: (any Error)?) {
            
        }
        
        override init () {
            super.init()
            self.startListening(self)
        }
        
    }
    
    class MockGameTemporaryStorage : GPGameTemporaryStorage {
        
        var storage: [String : Any] = [:]
        
        func store ( _ value: Any, forKey key: String ) {
            storage[key] = value
        }
        
        func retrieve ( forKey key: String ) -> Any? {
            storage[key]
        }
        
    }
    
}
