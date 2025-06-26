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
            sources: "SpeedTest/Sources/**",
            resources: "SpeedTest/Resources/**",
            dependencies: [
                .target(name: "CoreInterface"),
                .target(name: "SpeedTestUI"),
            ]
        ),
        .dynamicModule(name: "CoreInterface"),
        .dynamicModule(
            name: "SpeedTestUI",
            hasResources: true
        ),
    ]
)
