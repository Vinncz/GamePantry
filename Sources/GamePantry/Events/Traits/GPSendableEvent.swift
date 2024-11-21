/// Typealias for ``GPEvents`` that can be sent across the network, via ``GPNetworkBroadcaster`` object(s).
public typealias GPSendableEvent = GPHoldsPayload & GPRepresentableAsData
