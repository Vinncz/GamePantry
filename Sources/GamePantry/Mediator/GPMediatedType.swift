import Foundation

@available(*, deprecated)
public enum GPMediatedType : String {
    case server,
         serverAdvertiser,
         client,
         clientBrowser,
         networkManager,
         eventBroadcaster,
         eventReceiver
}
