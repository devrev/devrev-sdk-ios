import Foundation
import UIKit
import DevRevSDK

class AppDelegate: NSObject, UIApplicationDelegate {
	// MARK: - Configuration

	#warning("The sample app needs a development team set for code signing.")
	#warning("Enter your credentials here!")
	private let appID = "DvRvStPZG9uOmNvcmU6ZHZydi11cy0xOmRldm8vM2ZBSEVDOnBsdWdfc2V0dGluZy8xX198fF9fMjAyNC0wNy0yOSAwOTozMjoxNC4xNjU1Mjc4NTggKzAwMDAgVVRDxlxendsDvRv"
	private let testOrganizer = UITestOrganizer()

	// MARK: - App lifecycle

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {
		guard
			let	appID = testOrganizer.isInTestMode ? testOrganizer.appID : appID
		else {
			fatalError("Missing app ID for testing")
		}

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
