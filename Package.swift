// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ViewComponents",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(name: "ClientView", targets: ["ClientView"]),
    .library(name: "LevelIndicatorView", targets: ["LevelIndicatorView"]),
    .library(name: "LoginView", targets: ["LoginView"]),
    .library(name: "LogView", targets: ["LogView"]),
    .library(name: "PickerView", targets: ["PickerView"]),
    .library(name: "ProgressView", targets: ["ProgressView"]),
    .library(name: "RemoteView", targets: ["RemoteView"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.32.0"),
  ],
  targets: [
    // --------------- Modules ---------------
    // ClientView
    .target(name: "ClientView", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LevelIndicatorView
    .target(name: "LevelIndicatorView", dependencies: []),
    
    // LoginView
    .target(name: "LoginView", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // LogView
    .target(name: "LogView", dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // PickerView
    .target(name: "PickerView", dependencies: [
      "ClientView",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // ProgressView
      .target(name: "ProgressView",  dependencies: [
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),
    
    // RemoteView
    .target(name: "RemoteView",  dependencies: [
      "LoginView",
      "ProgressView",
      .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    ]),

    // --------------- Tests ---------------
    // ClientViewTests
    .testTarget(name: "ClientViewTests", dependencies: ["ClientView"]),

    // LevelIndicatorViewTests
    .testTarget(name: "LevelIndicatorViewTests", dependencies: ["LevelIndicatorView"]),
    
    // LoginViewTests
    .testTarget(name: "LoginViewTests", dependencies: ["LoginView"]),

    // LogViewTests
    .testTarget(name: "LogViewTests", dependencies: ["LogView"]),

    // PickerViewTests
    .testTarget(name: "PickerViewTests", dependencies: ["PickerView"]),

    // ProgressViewTests
    .testTarget(name: "ProgressViewTests", dependencies: ["ProgressView"]),

    // RemoteViewTests
    .testTarget(name: "RemoteViewTests", dependencies: ["RemoteView"]),
  ]
)
