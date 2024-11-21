import MultipeerConnectivity

/// The base class for objects which are able to 'talk' to devices in the network.
/// 
/// # Overview
/// Use the ``GPNetworkBroadcaster`` object to send data, files, and streams of data to a set of connected devices. 
/// 
/// # Usage
/// Treat the ``GPNetworkBroadcaster`` object as a mouth, from which you can speak to devices in the network.
/// Its frequently used in tandem with ``GPNetworkListener``, which listens for incoming data.
/// 
/// ```swift
/// let myAddress = MCPeerID(displayName: "Greg")
/// let myMic   = Microphone(usingIdentifierOf: myAddress) // A class which extends GPNetworkBroadcaster
/// let myRadio = MyRadio(usingIdentifierOf: myAddress)    // A class which extends GPNetworkListener
/// 
/// mic.pair(radio) // Pair the 'mouth' with the 'ear'
/// 
/// /*----------------------------*/
/// 
/// let herAddress = MCPeerID(displayName: "Alice")
/// let herMic   = Microphone(usingIdentifierOf: herAddress)
/// let herRadio = MyRadio(usingIdentifierOf: herAddress)
/// 
/// herMic.pair(herRadio)
/// 
/// /*----------------------------*/
/// 
/// try myMic.broadcast (
///     "Hello, world!".data(using: .utf8)!, 
///     to: herAddress
/// ) 
/// 
/// // herRadio will recieve "Hello, world!"
/// ```
open class GPNetworkBroadcaster : NSObject {
    
    private var emitter : Emitter!
    private class Emitter : MCSession {
        
        weak var attachedTo : GPNetworkBroadcaster?
        
        init ( for broadcaster: GPNetworkBroadcaster, securityIdentity: [Any]? = nil, encryptionPreference: MCEncryptionPreference = .optional ) {
            self.attachedTo = broadcaster
            super.init (
                peer                 : broadcaster.broadcastingFor,
                securityIdentity     : securityIdentity,
                encryptionPreference : encryptionPreference
            )
        }
        
    }
    public let broadcastingFor : MCPeerID
    
    public init ( serves target: MCPeerID ) {
        self.broadcastingFor = target
        
        super.init()
        
        self.emitter = Emitter(for: self)
    }
    
}

extension GPNetworkBroadcaster {
    
    /// Broadcasts some thing in ``Data`` form, to a set of recipients.
    public final func broadcast ( _ payload: Data, to recipients: [MCPeerID] ) throws {
        try self.emitter.send(payload, toPeers: recipients, with: .reliable)
    }
    
    /// Sends a resource in the given URL to a recipient.
    public final func send ( resourceAt: URL, to: MCPeerID, context: String, eventHandler: (((any Error)?) -> Void)? ) -> Progress? {
        return self.emitter.sendResource(at: resourceAt, withName: context, toPeer: to, withCompletionHandler: eventHandler)
    }
    
    /// Streams data from an input stream to a recipient.
    public final func stream ( _ stream: InputStream, context: String, to: MCPeerID ) throws -> OutputStream {
        return try self.emitter.startStream(withName: context, toPeer: to)
    }
    
}

extension GPNetworkBroadcaster {
    
    /// Pairs self with a ``GPNetworkListener`` object, enabling two-way communication between devices in the network.
    public final func pair ( _ eventListener: GPNetworkListener ) throws -> Self {
        self.emitter.delegate = try eventListener.portAsDelegate()
        return self
    }
    
    /// Approves the requests the likes of ``GPGameClientBrowser`` and ``GPGameServerAdvertiser`` make to self.
    /// 
    /// # Overview
    /// Imagine a scenario where a ``GPGameClientBrowser`` object selects a server, and requests to join it.
    /// It can only join the server, should its request get transmitted to the server.
    /// This is the method where you get to chose whether to forward the request to the server or not.
    public final func approve ( _ request : @escaping ( _ signed: MCSession ) -> Void ) {
        request(self.emitter)
    }
    
}

extension GPNetworkBroadcaster {
    
    /// Returns the list of peers who chose to subscribe to self's broadcasts.
    public final func getPeers () -> [MCPeerID] {
        return self.emitter.connectedPeers
    }
    
}
extension GPNetworkBroadcaster {
    
    /// Conditions self to dissapear from the network, and subsequently, terminate any subscriptions of other ``GPNetworkListener`` objects from listening to self.
    public final func disconnect () {
        self.emitter.disconnect()
    }
    
    /// Resets self to how it was when it was first initialized.
    public final func reset () {
        let existingDelegate  = self.emitter.delegate
        self.emitter          = Emitter(for: self)
        self.emitter.delegate = existingDelegate
    }
    
}
