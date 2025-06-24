import ProjectDescription

let project = Project(
    name: "UbiquitySpeedTest",
    settings: .settings(base: [
        "EAGER_LINKING": true,
        "ENABLE_USER_SCRIPT_SANDBOXING": true,
        "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
    ]),
    targets: [
        .target(
            name: "SpeedTest",
            destinations: .iOS,
            product: .app,
            bundleId: "cz.olejnjak.ubiquityspeedtest",
            sources: "SpeedTest/Sources/**",
            dependencies: [
                .target(name: "CoreInterface"),
                .target(name: "SpeedTestUI"),
            ]
        ),
    ]
)
