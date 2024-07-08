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
		showSupportButton.isEnabled = identifyButton.isEnabled
	}

	@IBAction func identify(_ sender: UIButton) {
		guard let userID = userIDTextField.text
		else {
			return
		}

		Task { @MainActor in
			await DevRev.identify(Identification(userID: userID))
		}
	}

	@IBAction func showSupport(_ sender: UIButton) {
		guard DevRev.isInitialized
		else {
			return
		}

		DevRev.showSupport(from: self)
	}
}
