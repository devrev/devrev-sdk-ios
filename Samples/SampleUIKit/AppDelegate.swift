import UIKit
import DevRevSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	#error("The sample app needs a development team set for code signing.")
	#error("Enter your credentials here!")
	private let appID = "<APPID>"
	private let appVersionKey = "<VERSION_KEY_HERE>"

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		DevRev.configure(appID: appID)
		DevRev.startRecording(appVersionKey)

		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		UISceneConfiguration(name: "Default Configuration",
							 sessionRole: connectingSceneSession.role)
	}
}
