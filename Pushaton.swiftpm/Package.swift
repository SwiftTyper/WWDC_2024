// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Pushaton",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Pushaton",
            targets: ["AppModule"],
            bundleIdentifier: "com.Wit.O.Pushaton",
            teamIdentifier: "9S3338F94S",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.green),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .camera(purposeString: "It is necessary to continue")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .copy("Resources/PushupClassifierV3.mlmodelc"),
                .copy("Resources/Audio/background.mp3"),
                .copy("Resources/Audio/countdown.wav"),
                .copy("Resources/Audio/box crash.mp3"),
                .copy("Resources/Audio/death.mp3"),
                .copy("Resources/Audio/jump.wav"),
                .copy("Resources/Audio/record.mp3"),
                .copy("Resources/Audio/reward.wav"),
                .process("Resources/PixeloidSans-Bold.ttf")
            ]
        )
    ]
)
