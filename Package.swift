// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DynamicBottomSheet",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "DynamicBottomSheet", targets: ["DynamicBottomSheet"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "DynamicBottomSheet",
            dependencies: ["RxSwift", "RxCocoa", "RxGesture", "SnapKit", "Then"],
            path: "DynamicBottomSheet/Classes"
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
