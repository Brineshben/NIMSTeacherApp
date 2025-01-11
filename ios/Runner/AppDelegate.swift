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
        // Configure Firebase
        FirebaseApp.configure()

        // Set notification delegate
//         UNUserNotificationCenter.current().delegate = self

        // Restore Google Sign-In
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Error restoring previous sign-in: \(error.localizedDescription)")
            } else if let user = user {
                print("Successfully signed in as \(user.profile?.email ?? "No email")")
            }
        }

        // Register for remote notifications
//         application.registerForRemoteNotifications()

        // Handle FCM token updates
//         Messaging.messaging().delegate = self

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

//     override func userNotificationCenter(
//         _ center: UNUserNotificationCenter,
//         willPresent notification: UNNotification,
//         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//     ) {
//         // Show banner, sound, and badge for foreground notifications
//         completionHandler([.banner, .sound, .badge])
//     }
}

// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("FCM Token: \(token)")
        // Send the token to your server if required
    }
}
