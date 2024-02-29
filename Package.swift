// swift-tools-version:5.3
import PackageDescription

let version = "4.9.0"

let package = Package(
    name: "Jumio",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Jumio",
            targets: ["JumioBundle"]
        ),
        .library(
            name: "JumioLiveness",
            targets: ["JumioLivenessBundle"]
        ),
    ],
    dependencies: [ ],
    targets: [
        .target(name: "JumioBundle",
                dependencies: [
                    "Jumio"
                ]
               ),
        .target(name: "JumioLivenessBundle",
                dependencies: [
                    "JumioBundle",
                    "JumioLiveness"
                ]
               ),
        .binaryTarget(
            name: "Jumio",
            url: "https://repo.mobile.jumio.ai/com/jumio/ios/jumio-mobile-sdk/\(version)/Jumio.xcframework.zip",
            checksum: "87490d4ade767ed3352abad933b867e0d291f35d0b3bb8bd931cb09dac37ba7b"
        ),
        .binaryTarget(
            name: "JumioLiveness",
            url: "https://repo.mobile.jumio.ai/com/jumio/ios/jumio-mobile-sdk/\(version)/JumioLiveness.xcframework.zip",
            checksum: "3d5594ee8157c3bfe2258cfc0eed5198742873ad68f36a0c0603f384abecff7f"
        ),
    ]
)
