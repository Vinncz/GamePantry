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
                "Events/GPEvent.swift",
                    "Events/GPHoldsEvents.swift",
                    "Events/GPRespondsToEvents.swift",
                    "Events/GPBlacklistedEvent.swift",
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
