// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Mindbox",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "Mindbox",
            targets: ["Mindbox"]),
        .library(
            name: "MindboxNotificationsService",
            targets: ["MindboxNotifications"]),
        .library(
            name: "MindboxNotificationsContent",
            targets: ["MindboxNotifications"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Mindbox",
            dependencies: ["SDKVersionProvider", "MindboxLogger"],
            path: "Mindbox",
            exclude: ["Info.plist"]
        ),
        .target(
            name: "MindboxNotifications",
            dependencies: ["SDKVersionProvider", "MindboxLogger"],
            path: "MindboxNotifications",
            exclude:  ["Info.plist"]
        ),
        .target(
            name: "SDKVersionProvider",
            path: "SDKVersionProvider"
        ),
        .target(
            name: "MindboxLogger",
            path: "MindboxLogger"
        )
    ]
)
