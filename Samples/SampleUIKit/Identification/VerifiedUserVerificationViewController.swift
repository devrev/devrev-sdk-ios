import Foundation
import UIKit
import DevRevSDK

class VerifiedUserVerificationViewController: UITableViewController {
	private var items: [ActionableMenuItem] = [
		.init(title: NSLocalizedString("User ID Input", comment: ""), destination: nil),
		.init(title: NSLocalizedString("Session Token Input", comment: ""), destination: nil),
		.init(title: NSLocalizedString("Verify User", comment: ""), destination: nil)
	]

	private let userIDTextField = TextField(frame: .zero, placeholder: "User ID")
	private let sessionTokenTextField = TextField(frame: .zero, placeholder: "Session Token")

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Verified User Identify", comment: "")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.verifiedUserIdentification)
		view.backgroundColor = .systemBackground
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: Constants.CellIdentifier.verifiedUserIdentification,
			for: indexPath
		)

		cell.contentView.subviews.forEach { $0.removeFromSuperview() }

		switch indexPath.row {
		case 0:
			cell.contentView.addSubview(userIDTextField)
			NSLayoutConstraint.activate([
				userIDTextField.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
				userIDTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
				userIDTextField.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.8)
			])
			cell.selectionStyle = .none
		case 1:
			cell.contentView.addSubview(sessionTokenTextField)
			NSLayoutConstraint.activate([
				sessionTokenTextField.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
				sessionTokenTextField.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
				sessionTokenTextField.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.8)
			])
			cell.selectionStyle = .none
		case 2:
			cell.textLabel?.text = NSLocalizedString("Verify User", comment: "")
		default:
			break
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard
			indexPath.row == 2
		else {
			tableView.deselectRow(at: indexPath, animated: true)
			return
		}

		verifyUser()
	}

	@objc private func verifyUser() {
		guard
			let enteredUserID = userIDTextField.text, !enteredUserID.isEmpty,
			let enteredSessionToken = sessionTokenTextField.text, !enteredSessionToken.isEmpty
		else {
			return
		}

		Task {
			await DevRev.identifyVerifiedUser(enteredUserID, sessionToken: enteredSessionToken)
			AlertPresenter
				.show(
					on: self,
					title: NSLocalizedString("User Identify", comment: ""),
					message: NSLocalizedString("User identified as verified.", comment: "")
				)
		}
	}
}
