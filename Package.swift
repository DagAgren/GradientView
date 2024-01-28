// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "GradientView",
	platforms: [
	   .iOS(.v17)
	],
	products: [
		.library(
			name: "GradientView",
			targets: ["GradientView"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		.target(
			name: "GradientView",
			path: ".",
			exclude: ["Snapshotter"]
		),
		.testTarget(
			name: "Snapshotter",
			dependencies: ["GradientView"],
			path: "Snapshotter"
		),
	]
)
