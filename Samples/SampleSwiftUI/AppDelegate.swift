import Foundation
import UIKit
import DevRevSDK

class AppDelegate: NSObject, UIApplicationDelegate {
	// MARK: - Configuration

//	#error("The sample app needs a development team set for code signing.")
//	#error("Enter your credentials here!")
	private let appID = "DvRvStPZG9uOmNvcmU6ZHZydi11cy0xOmRldm8vODA1OnBsdWdfc2V0dGluZy8xX198fF9fMjAyNC0wOC0zMCAwOTozOTozNS4zNjczNzE0MDYgKzAwMDAgVVRDxlxendsDvRv"

	// MARK: - App lifecycle

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {

		DevRev.configure(appID: appID)

		Task { @MainActor in
			await requestPushNotificationsAuthorization()
		}

		return true
	}

	// MARK: - Push notifications

	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		guard
			let deviceID = UIDevice.current.identifierForVendor?.uuidString
		else {
			return
		}

		Task {
			await DevRev.registerDeviceToken(
				deviceToken,
				deviceID: deviceID
			)
		}
	}

	private func requestPushNotificationsAuthorization() async {
		do {
			let center = UNUserNotificationCenter.current()
			try await center.requestAuthorization(options: [.alert, .sound, .badge])
		} catch {
			print("Could not request authorization for push notifications: \(error)")
		}
	}
}
