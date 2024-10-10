// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GamePantry",
    platforms: [.macOS(.v14), .iOS(.v17), .tvOS(.v17)],
    products: [
        .library(
            name: "GamePantry",
            targets: ["GamePantry"]
        ),
    ],
    targets: [
        .target(
            name: "GamePantry",
            sources: [
                "Mediator/GPMediator.swift",
                "Mediator/GPMediated.swift",
                "Mediator/GPMediatedType.swift",
                "Events/GPEvent.swift",
                "Events/GPHandlesEvents.swift",
                "Events/GPEmitsEvents.swift",
                "Events/GPHoldsEvents.swift",
                "Events/GPRespondsToEvents.swift",
                        "Events/Controls/GPEventRouter.swift",
                        "Events/Implementations/GPAcquaintanceStatusUpdateEvent.swift",
                        "Events/Implementations/GPAnyEvent.swift",
                        "Events/Implementations/GPBlacklistedEvent.swift",
                        "Events/Implementations/GPGameEndedEvent.swift",
                        "Events/Implementations/GPGameEndRequestedEvent.swift",
                        "Events/Implementations/GPGameJoinRequestedEvent.swift",
                        "Events/Implementations/GPGameJoinVerdictDeliveredEvent.swift",
                        "Events/Implementations/GPGameStartRequestedEvent.swift",
                        "Events/Implementations/GPTerminatedEvent.swift",
                        "Events/Implementations/GPUnableToAdvertiseEvent.swift",
                        "Events/Implementations/GPUnableToBrowseEvent.swift",
                        "Events/Traits/GPConstructibleFromPayload.swift",
                        "Events/Traits/GPHoldsPayload.swift",
                        "Events/Traits/GPSendableEvent.swift",
                        "Events/Traits/GPReceivableEvent.swift",
                "Utilities/GPRepresentableAsData.swift",
                "Utilities/fdataFrom.swift",
                "Utilities/ffromData.swift",
                "Extensions/Data.swift",
                "Extensions/GPAnySubject.swift",
                "GPGameProcess.swift",
                "GPGameTemporaryStorage.swift",
                "GPGameProcessConfiguration.swift",
                "GPGameEventBroadcaster.swift",
                "GPGameEventListener.swift",
                "GPNetworkManager.swift",
                "Client/GPGameClient.swift",
                    "Client/GPGameClientNetworkManager.swift",
                    "Client/GPGameClientBrowser.swift",
                    "Client/GPGameServerDiscoveryReport.swift",
                "Server/GPGameServer.swift",
                    "Server/GPGameServerNetworkManager.swift",
                    "Server/GPGameServerAdvertiser.swift",
                    "Server/GPGameJoinRequest.swift",
            ]
        ),
        .testTarget(
            name: "GamePantryTests",
            dependencies: ["GamePantry"]
        ),
    ]
)
