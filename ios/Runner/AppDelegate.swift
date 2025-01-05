import Flutter
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    UNUserNotificationCenter.current().delegate = self
//     GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if let error = error {
            print("Error restoring previous sign-in: \(error.localizedDescription)")
        } else if let user = user {
            print("Successfully signed in as \(user.profile?.email ?? "No email")")
        }
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
