// swift-tools-version:5.6
 import PackageDescription
 let version = "3.3.13003"
 let package = Package(
     name: "Apptics",
     defaultLocalization: "en",
     platforms: [.macOS(.v10_10), .iOS(.v13), .tvOS(.v9), .watchOS(.v2)],
     products: [
         .library(
             name: "AppticsFeedbackKit",
             targets: ["AppticsFeedbackKit"]
         ),
         .library(
             name: "AppticsInAppUpdate",
             targets: ["AppticsInAppUpdate"]
             
         ),
         .library(
             name: "AppticsRateUs",
             targets: ["AppticsRateUs"]
         ),
         .library(
             name: "AppticsRemoteConfig",
             targets: ["AppticsRemoteConfig"]
         ),
         .library(
             name: "AppticsApiTracker",
             targets: ["AppticsApiTracker"]
         ),
         .library(
             name: "AppticsExtension",
             targets: ["AppticsExtension"]
         ),
         .library(
             name: "AppticsAnalytics",
             targets: ["AppticsAnalytics"]
         ),
         .library(
             name: "AppticsAnalyticscoreWithKSCrash",
             targets: ["AppticsAnalyticscoreWithKSCrash"]
         ),
         .library(
             name: "AppticsCrossPromotion",
             targets: ["AppticsCrossPromotion"]
         ),
         .library(
             name: "AppticsFeedbackKitSwift",
             targets: ["AppticsFeedbackKitSwift"]
         ),
         .library(
             name: "AppticsFeedbackKitSwiftMacOS",
             targets: ["AppticsFeedbackKitSwiftMacOS"]
         ),
         .library(
             name: "AppticsPrivacyShield",
             targets: ["AppticsPrivacyShield"]
         ),
         .library(
             name: "AppticsMessaging",
             targets: ["AppticsMessaging"]
         ),
         .library(
             name: "AppticsNotificationServiceExtension",
             targets: ["AppticsNotificationServiceExtension"]
         ),
         .library(
             name: "AppticsNotificationContentExtension",
             targets: ["AppticsNotificationContentExtension"]
         )
     ],
     targets: [
         .binaryTarget(
             name: "JWT",
             path: "Apptics/JWT.xcframework"
         ),
         .binaryTarget(
             name: "Apptics",
             path: "Apptics/Apptics.xcframework"
         ),
         .binaryTarget(
             name: "AppticsEventTracker",
             path: "Apptics/AppticsEventTracker.xcframework"
         ),
         .binaryTarget(
             name: "AppticsScreenTracker",
             path: "Apptics/AppticsScreenTracker.xcframework"
         ),
         .binaryTarget(
             name: "AppticsCrashKit",
             path: "Apptics/AppticsCrashKit.xcframework"
         ),
         .binaryTarget(
             name: "KSCrash",
             path: "Apptics/KSCrash.xcframework"
         ),
         .binaryTarget(
             name: "AppticsMXCrashKit",
             path: "Apptics/AppticsMXCrashKit.xcframework"
         ),
         .binaryTarget(
             name: "AppticsFeedbackKit",
             path: "AppticsFeedbackKit.xcframework"
         ),
         .binaryTarget(
             name: "AppticsInAppUpdate",
             path: "AppticsInAppUpdate.xcframework"
         ),
         .binaryTarget(
             name: "AppticsRateUs",
             path: "AppticsRateUs.xcframework"
         ),
         .binaryTarget(
             name: "AppticsRemoteConfig",
             path: "AppticsRemoteConfig.xcframework"
         ),
         .binaryTarget(
             name: "AppticsApiTracker",
             path: "AppticsApiTracker.xcframework"
         ),
         .binaryTarget(
             name: "AppticsPrivacyShield",
             path: "AppticsPrivacyShield.xcframework"
         ),
         .binaryTarget(
             name: "AppticsMessaging",
             path: "AppticsMessaging.xcframework"
         ),
         .binaryTarget(
             name: "AppticsNotificationServiceExtension",
             path: "AppticsNotificationServiceExtension.xcframework"
         ),
         .binaryTarget(
             name: "AppticsNotificationContentExtension",
             path: "AppticsNotificationContentExtension.xcframework"
         ),
         .target(
             name: "AppticsExtension",
             path: "SwiftFiles/AppExtension",
             resources: [
                 .copy("PrivacyInfo.xcprivacy")]
         ),
         .target(
             
             name: "AppticsAnalytics",
             dependencies: [
                "Apptics",
                "JWT",
                "AppticsEventTracker",
                "AppticsScreenTracker",
                .target(name: "AppticsMXCrashKit", condition: .when(platforms: [.iOS]))
            ], path: "SwiftFiles/Analytics"
         ),
         .target(
             
             name: "AppticsAnalyticscoreWithKSCrash",
             dependencies: ["Apptics", "JWT", "AppticsEventTracker", "AppticsScreenTracker", "AppticsCrashKit", "KSCrash"], path: "SwiftFiles/AnalyticswithkSCrash"
         ),
         .target(
             name: "AppticsCrossPromotion",
             dependencies: ["AppticsAnalytics"],
             path: "SwiftFiles/CrossPromoApps",
             resources: [
                 .copy("PrivacyInfo.xcprivacy"),
                 .process("PromotedAppsController.xib"),
                 .process("PromotedAppViewCell.xib"),
                 .copy("Fonts/Apptics-CP.ttf")
             ]
         ),
         .target(
             name: "AppticsFeedbackKitSwift",
             dependencies: ["AppticsFeedbackKit"],
             path: "SwiftFiles/AppticsFeedbackKit",
             resources: [
                 .copy("PrivacyInfo.xcprivacy"),
                 .copy("AppticsSdkIcons.ttf"),
                 .copy("FloatingView.xib"),
                 .copy("ScreenShotEditorView.xib"),
                 .copy("ScreenShotView.xib"),
                 .copy("QuartzResources.bundle")
             ]
         ),
         .target(
                     name: "AppticsFeedbackKitSwiftMacOS",
                     dependencies: ["AppticsFeedbackKit"],
                     path: "SwiftFiles/AppticsMacFeedbackKit",
                     resources: [
                         .copy("AttachementFeed.png"),
                         .copy("messageIcon.png"),
                         .copy("Close.png"),
                         .copy("Info.png"),
                         .copy("AppticsFeedbackViewController.xib"),
                         .copy("CollectionCell.xib"),
                         .copy("PrivacyInfo.xcprivacy")
                     ]
                 )
     ]
)
