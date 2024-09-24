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
                "GamePantry.swift",
                    "Process/GPGameClient.swift",
                    "Process/GPGameProcess.swift",
                    "Process/GPGameProcessConfiguration.swift",
                    "Process/GPGameServer.swift",
                        "Process/Shared/GPGameEventBroadcaster.swift",
                        "Process/Shared/GPGameEventListener.swift",
                        "Process/Shared/GPGameTemporaryStorage.swift",
                    "Networks/GPNetworkManager.swift",
                        "Networks/Client/GPGameClientNetworkManager.swift",
                        "Networks/Client/GPGameClientBrowser.swift",
                        "Networks/Client/GPGameServerDiscoveryReport.swift",
                        "Networks/Server/GPGameServerNetworkManager.swift",
                        "Networks/Server/GPGameServerAdvertiser.swift",
                        "Networks/Server/GPGameJoinRequest.swift",
            ]
        ),
        .testTarget(
            name: "GamePantryTests",
            dependencies: ["GamePantry"]
        ),
    ]
)
