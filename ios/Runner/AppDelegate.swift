import Flutter
import GoogleMaps
import GooglePlaces
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBZz4unF-wEdjkLUM6jOI8TSKu8E-CisnM")
    GMSPlacesClient.provideAPIKey("AIzaSyBZz4unF-wEdjkLUM6jOI8TSKu8E-CisnM")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
