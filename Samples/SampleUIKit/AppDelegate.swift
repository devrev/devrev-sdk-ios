import UIKit
import DevRevSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	#error("The sample app needs a development team set for code signing.")
	#error("Enter your credentials and support ID here!")
	private let appID = "<APPID>"
	private let secret = "<SECRET>"
	private let supportID = "<SUPPORT_ID>"

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		DevRev.configure(appID: appID,
						 secret: secret,
						 supportID: supportID)

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
