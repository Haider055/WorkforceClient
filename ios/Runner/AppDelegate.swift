import Flutter
import UIKit
import GoogleMaps
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {

  var flutterChannel: FlutterMethodChannel?  // 👈 add this

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    GMSServices.provideAPIKey("AIzaSyBZz4unF-wEdjkLUM6jOI8TSKu8E-CisnM")

    // 👇 setup method channel
    let controller = window?.rootViewController as! FlutterViewController
    flutterChannel = FlutterMethodChannel(
      name: "app/lifecycle",
      binaryMessenger: controller.binaryMessenger
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 👇 fires when app is swiped away on iOS
  override func applicationWillTerminate(_ application: UIApplication) {
    flutterChannel?.invokeMethod("onAppTerminate", arguments: nil)
    Thread.sleep(forTimeInterval: 3.0)
  }

  override func applicationDidEnterBackground(_ application: UIApplication) {
    var bgTaskID = UIBackgroundTaskIdentifier.invalid
    bgTaskID = application.beginBackgroundTask(withName: "mark_messages_read") {
      application.endBackgroundTask(bgTaskID)
      bgTaskID = .invalid
    }
    DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
      application.endBackgroundTask(bgTaskID)
      bgTaskID = .invalid
    }
  }
}
