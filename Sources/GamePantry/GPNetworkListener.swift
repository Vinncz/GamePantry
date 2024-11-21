import MultipeerConnectivity

/// The base type for objects which 'listens' for transmissions of ``GPNetworkBroadcaster`` objects in the network.
/// 
/// # Overview
/// Use in tandem with ``GPNetworkBroadcaster``, to create a network of devices that can communicate with each other.
/// 
/// # Usage
/// Treat the ``GPNetworkListener`` object as an ear, from which you can listen for things happening in the network.
/// You can choose to tune in or out of the network by calling ``undeafen(_:)`` and ``deafen(_:)`` respectively.
/// 
/// ```swift
/// let radio = MyRadio()    // A class that conforms to GPNetworkListenerProtocol
///     radio.undeafen(self) // Radio will now listen for incoming transmissions, and you can hear them through the methods of MyRadio
///     radio.deafen(self)   // Radio will no longer listen for incoming transmissions
/// ```
///
public typealias GPNetworkListener = GPNetworkListenerSC & GPNetworkListenerProtocol

/// The base protocol for objects which 'listens' for transmissions of ``GPNetworkBroadcaster`` objects in the network.
/// 
/// # Overview
/// Use the ``GPNetworkListenerProtocol`` to facade the methods of ``MCSessionDelegate`` to a readable and more contextual form.
/// 
/// - Warning: Refrain from implementing this protocol outside the environment of GamePantry framework. This was made public since Swift limits public typealiases to only reference types which are public.
public protocol GPNetworkListenerProtocol {
    
    /// Called when self hears a connection-state change of a peer, should they are connected to the session.
    func heardNews ( of: MCPeerID, to: MCSessionState )
    
    /// Called when self hears transmission of data from a peer.
    func heardData ( from peer: MCPeerID, _ data: Data )
    
    /// Called when self hears a request for an incoming stream from a peer.
    func heardIncomingStreamRequest ( from peer: MCPeerID, _ stream: InputStream, withContextOf context: String )
    
    /// Called when self hears a request for an incoming resource transfer from a peer.
    func heardIncomingResourceTransfer ( from peer: MCPeerID, withContextOf context: String, withProgress progress: Progress )
    
    /// Called when self hears the completion of an incoming resource transfer from a peer.
    func heardCompletionOfResourceTransfer ( context: String, sender: MCPeerID, savedAt: URL?, withAccompanyingErrorOf: (any Error)? )
    
    /// Called when self hears a certificate from a peer.
    func heardCertificate ( from peer: MCPeerID, _ certificate: [Any]?, _ certificateHandler: @escaping (Bool) -> Void )
    
}

/// The base class for objects which 'listens' for transmissions of ``GPNetworkBroadcaster`` objects in the network.
/// 
/// # Overview
/// Abstracts the implementation of ``MCSessionDelegate``, and maps the methods related to incoming data, streams, and resources to the methods of a given ``GPNetworkListenerProtocol`` object through initialization.
/// 
/// # Usage
/// Treat the ``GPNetworkListener`` object as an ear from which you can listen for things happening in the network.
/// You can choose to tune in or out of the network by calling ``undeafen(_:)`` and ``deafen(_:)`` respectively.
/// 
/// ```swift
/// let radio = MyRadio()    // A class that conforms to GPNetworkListenerProtocol
///     radio.undeafen(self) // Radio will now listen for incoming transmissions, and you can hear them through the methods of MyRadio
///     radio.deafen(self)   // Radio will no longer listen for incoming transmissions
/// ```
/// 
/// - Warning: Refrain from implementing this protocol outside the environment of GamePantry framework. This was made public since Swift limits public typealiases to only reference types which are public.
open class GPNetworkListenerSC : NSObject {
    
    /// The internal ear that listens for incoming transmissions.
    private var ear   : Ear?
    private class Ear : NSObject, MCSessionDelegate {
        
        weak var attachedTo : GPNetworkListener?
        
        init ( for listener: GPNetworkListener ) {
            self.attachedTo = listener
        }
        
        func session ( _ session: MCSession, peer peerID: MCPeerID, didChange newState: MCSessionState ) {
            attachedTo?.heardNews(of: peerID, to: newState)
        }
        
        func session ( _ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardData(from: peerID, data)
        }
        
        func session ( _ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID ) {
            attachedTo?.heardIncomingStreamRequest(from: peerID, stream, withContextOf: streamName)
        }
        
        func session ( _ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress ) {
            attachedTo?.heardIncomingResourceTransfer(from: peerID, withContextOf: resourceName, withProgress: progress)
        }
        
        func session ( _ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)? ) {
            attachedTo?.heardCompletionOfResourceTransfer(context: resourceName, sender: peerID, savedAt: localURL, withAccompanyingErrorOf: error)
        }
        
        func session ( _ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void ) {
            attachedTo?.heardCertificate(from: peerID, certificate, certificateHandler)
        }
    }
        
}

extension GPNetworkListenerSC {
    
    /// Condition self to listen for transmissions from a ``GPNetworkBroadcaster`` object in the network.
    public final func undeafen ( _ instance: GPNetworkListener ) {
        instance.ear = Ear( for: instance )
    }
    
    /// Condition self to not listen for transmissions from a ``GPNetworkBroadcaster`` object in the network.
    public final func deafen ( _ instance: GPNetworkListener ) {
        instance.ear = nil
    }
    
    /// Opens self to pair with a ``GPNetworkBroadcaster`` object. Do so to enable two-way communication (talk and listen) between devices in the network.
    /// 
    /// Throws ``GPError.unableToPair`` should self is deafened.
    public final func portAsDelegate () throws -> MCSessionDelegate {
        guard let ear else { 
            throw GPError.unableToPair("Did you forget to call undeafen(_:) on \(self)? ")
        } 
        
        return ear
    }
    
}
