// swift-tools-version: 5.6
import PackageDescription

let swiftSettings: [SwiftSetting] = [
  .unsafeFlags(
    [
      "-Xfrontend",
      "-debug-time-function-bodies",
      "-Xfrontend",
      "-debug-time-expression-type-checking",
    ],
    .when(configuration: .debug)
  ),
]

let package = Package(
  name: "example-app",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "ErrorFeature", targets: ["ErrorFeature"]),
    .library(name: "LandingFeature", targets: ["LandingFeature"]),
    .library(name: "SessionFeature", targets: ["SessionFeature"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      .upToNextMajor(from: "0.39.0")
    ),
    .package(
      url: "https://github.com/darrarski/swift-composable-presentation.git",
      .upToNextMajor(from: "0.5.2")
    ),
    .package(
      // ElixxirDAppsSDK
      path: "../../"
    ),
    .package(
      url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
      .upToNextMajor(from: "4.2.2")
    ),
    .package(
      url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git",
      .upToNextMajor(from: "0.4.0")
    ),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        .target(name: "ErrorFeature"),
        .target(name: "LandingFeature"),
        .target(name: "SessionFeature"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "ElixxirDAppsSDK", package: "elixxir-dapps-sdk-swift"),
        .product(name: "KeychainAccess", package: "KeychainAccess"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "AppFeatureTests",
      dependencies: [
        .target(name: "AppFeature"),
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "ErrorFeature",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ElixxirDAppsSDK", package: "elixxir-dapps-sdk-swift"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "ErrorFeatureTests",
      dependencies: [
        .target(name: "ErrorFeature"),
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "LandingFeature",
      dependencies: [
        .target(name: "ErrorFeature"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "ElixxirDAppsSDK", package: "elixxir-dapps-sdk-swift"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "LandingFeatureTests",
      dependencies: [
        .target(name: "LandingFeature"),
      ],
      swiftSettings: swiftSettings
    ),
    .target(
      name: "SessionFeature",
      dependencies: [
        .target(name: "ErrorFeature"),
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "ComposablePresentation", package: "swift-composable-presentation"),
        .product(name: "ElixxirDAppsSDK", package: "elixxir-dapps-sdk-swift"),
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "SessionFeatureTests",
      dependencies: [
        .target(name: "SessionFeature"),
      ],
      swiftSettings: swiftSettings
    ),
  ]
)
