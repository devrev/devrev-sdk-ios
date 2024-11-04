import Foundation
import UIKit
import DevRevSDK

class ViewController: UIViewController {
	@IBOutlet weak var userIDTextField: UITextField!
	@IBOutlet weak var identifyButton: UIButton!
	@IBOutlet weak var showSupportButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func textFieldEditingChanged(_ sender: UITextField) {
		let isEmpty = sender.text?.isEmpty ?? false

		identifyButton.isEnabled = !isEmpty
	}

	@IBAction func identifyUnverifiedUser(_ sender: UIButton) {
		guard
			let userID = userIDTextField.text,
			!userID.isEmpty
		else {
			return
		}

		Task { @MainActor in
			await DevRev.identifyUnverifiedUser(Identity(userID: userID))
		}
	}

	@IBAction func showSupport(_ sender: UIButton) {
		Task {
			guard await DevRev.isUserIdentified
			else {
				return
			}
			
			await DevRev.showSupport(from: self)
		}
	}

	@IBAction func registerPushNotifications(_ sender: Any) {
		UIApplication.shared.registerForRemoteNotifications()
	}

	@IBAction func unregisterPushNotifications(_ sender: Any) {
		UIApplication.shared.unregisterForRemoteNotifications()

		Task {
			guard
				let deviceID = UIDevice.current.identifierForVendor?.uuidString
			else {
				return
			}

			await DevRev.unregisterDevice(deviceID)
		}
	}
}
