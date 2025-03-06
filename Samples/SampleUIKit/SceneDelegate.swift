import Foundation
import UIKit
import DevRevSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard
			let scene = scene as? UIWindowScene
		else {
			return
		}

		window = .init(windowScene: scene)
		let rootViewController = HomeViewController(style: .insetGrouped)
		let navigationController = UINavigationController(rootViewController: rootViewController)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}
