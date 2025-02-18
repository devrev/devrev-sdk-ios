import Foundation
import UIKit
import DevRevSDK

class UnverifiedUserIdentificationViewController: UITableViewController {
	private var items: [ActionableMenuItem] = [
		.init(title: NSLocalizedString("User ID Input", comment: ""), destination: nil),
		.init(title: NSLocalizedString("Identify User", comment: ""), destination: nil)
	]
	
	private let userIDTextField = TextField(frame: .zero, placeholder: "User ID")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Unverified User Identify", comment: "")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.unverifiedUserIdentification)
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: Constants.CellIdentifier.unverifiedUserIdentification,
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
			cell.textLabel?.text = NSLocalizedString("Identify User", comment: "")
		default:
			break
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard
			indexPath.row == 1
		else {
			tableView.deselectRow(at: indexPath, animated: true)
			return
		}

		verifyUser()
	}

	@objc private func verifyUser() {
		guard
			let enteredUserID = userIDTextField.text,
			!enteredUserID.isEmpty
		else {
			return
		}
		
		Task {
			await DevRev.identifyUnverifiedUser(Identity(userID: enteredUserID))
			AlertPresenter
				.show(
					on: self,
					title: NSLocalizedString("User Identify", comment: ""),
					message: NSLocalizedString("User identified as unverified.", comment: "")
				)
		}
	}
}
