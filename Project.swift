import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "UbiquitySpeedTest",
    settings: .settings(base: [
        "EAGER_LINKING": true,
        "ENABLE_USER_SCRIPT_SANDBOXING": true,
        "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
    ]),
    targets: [
        .target(
            name: "SpeedTest",
            destinations: .iOS,
            product: .app,
            bundleId: "cz.olejnjak.ubiquityspeedtest",
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:]
            ]),
            sources: "SpeedTest/Sources/**",
            resources: "SpeedTest/Resources/**",
            dependencies: [
                .target(name: "CoreInterface"),
                .target(name: "SpeedTestUI"),
                .target(name: "Servers"),
            ]
        ),
        .dynamicModule(name: "CoreInterface"),
        .dynamicModule(
            name: "SpeedTestUI",
            hasResources: true
        ),
        .target(
            name: "SimplePing",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "com.example.apple-samplecode.SimplePing",
            sources: "Modules/SimplePing/Sources/**",
            headers: .headers(
                public: "Modules/SimplePing/Sources/SimplePing.h"
            )
        ),
        .staticModule(
            name: "Servers",
            dependencies: [
                .target(name: "CoreInterface"),
                .target(name: "SimplePing"),
            ]
        ),
    ]
)
