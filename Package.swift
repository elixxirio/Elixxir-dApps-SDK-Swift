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
  name: "elixxir-dapps-sdk-swift",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v14),
  ],
  products: [
    .library(
      name: "ElixxirDAppsSDK",
      targets: ["ElixxirDAppsSDK"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-custom-dump.git",
      .upToNextMajor(from: "0.4.0")
    ),
  ],
  targets: [
    .target(
      name: "ElixxirDAppsSDK",
      dependencies: [
        .target(name: "Bindings"),
      ],
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "ElixxirDAppsSDKTests",
      dependencies: [
        .target(name: "ElixxirDAppsSDK"),
        .product(
          name: "CustomDump",
          package: "swift-custom-dump"
        ),
      ],
      swiftSettings: swiftSettings
    ),
    .binaryTarget(
      name: "Bindings",
      path: "Frameworks/Bindings.xcframework"
    ),
  ]
)