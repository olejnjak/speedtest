import ProjectDescription

public extension Target {
    static func staticModule(
        name: String,
        hasResources: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        .module(
            name: name,
            product: .staticFramework,
            hasResources: hasResources,
            dependencies: dependencies
        )
    }

    static func dynamicModule(
        name: String,
        hasResources: Bool = false,
        dependencies: [TargetDependency] = []
    ) -> Target {
        .module(
            name: name,
            product: .framework,
            hasResources: hasResources,
            dependencies: dependencies
        )
    }

    private static func module(
        name: String,
        product: Product,
        hasResources: Bool,
        dependencies: [TargetDependency]
    ) -> Target {
        .target(
            name: name,
            destinations: .iOS,
            product: product,
            bundleId: "cz.olejnjak." + name.lowercased(),
            sources: "Modules/\(name)/Sources/**",
            resources: hasResources ? "Modules/\(name)/Resources/**" : nil,
            dependencies: dependencies
        )
    }
}
