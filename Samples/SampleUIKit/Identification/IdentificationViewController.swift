import Foundation
import UIKit
import DevRevSDK

class IdentificationViewController: UITableViewController {
	private var userIdentification = NSLocalizedString("Not Identified yet", comment: "")
	private var items: [ActionableMenuItem] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Identification", comment: "")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.identification)
		initializeIdentificationItems()
		
		Task {
			guard
				await DevRev.isUserIdentified
			else {
				return
			}
			
			userIdentification = NSLocalizedString("User Identified", comment: "")
			
			DispatchQueue.main.async {
				self.items[0] = ActionableMenuItem(title: "User ID: \(self.userIdentification)", destination: nil)
				self.tableView.reloadData()
			}
		}
	}

	private func initializeIdentificationItems() {
		items = [
			.init(title: NSLocalizedString("User ID: \(userIdentification)", comment: ""), destination: nil),
			.init(
				title: NSLocalizedString("Unverified User Identification", comment: ""),
				destination: UnverifiedUserIdentificationViewController.self
			),
			.init(
				title: NSLocalizedString("Verified User Verification", comment: ""),
				destination: VerifiedUserVerificationViewController.self
			)
		]
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.identification, for: indexPath)
		cell.textLabel?.text = items[indexPath.row].title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let selectedItem = items[indexPath.row]
		guard
			let destinationViewController = selectedItem.destination
		else {
			return
		}
		
		let viewController = destinationViewController.init()
		navigationController?.pushViewController(viewController, animated: true)
	}
}
