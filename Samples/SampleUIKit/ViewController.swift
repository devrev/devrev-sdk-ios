import Foundation
import UIKit
import DevRevSDK

class ViewController: UITableViewController {
	private var isConfigured = false {
		didSet {
			tableView.reloadData()
		}
	}
	private var isUserIdentified = false {
		didSet {
			tableView.reloadData()
		}
	}
	
	private var items: [MenuItem] = [
		UserStatusMenuItem(title: NSLocalizedString("Is the DevRev SDK configured?", comment: ""), isUserIdentified: false),
		UserStatusMenuItem(title: NSLocalizedString("Is the user identified?", comment: ""), isUserIdentified: false),
		UserStatusMenuItem(title: NSLocalizedString("Is session monitoring enabled?", comment: ""), isUserIdentified: false),
		ActionableMenuItem(title: NSLocalizedString("Identification", comment: ""), destination: IdentificationViewController.self),
		ActionableMenuItem(title: NSLocalizedString("Push Notification", comment: ""), destination: PushNotificationViewController.self),
		ActionableMenuItem(title: NSLocalizedString("Support", comment: ""), destination: SupportViewController.self),
		ActionableMenuItem(title: NSLocalizedString("Session Analytics", comment: ""), destination: SessionAnalyticsViewController.self)
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Main Menu", comment: "")
		tableView.reloadData()
		Task {
			await checkIdentification()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkAndUpdateState()
	}

	private func checkAndUpdateState() {
		Task {
			await checkIdentification()
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}

	private func updateIdentificationStatus(status: Bool) {
		items[1] = UserStatusMenuItem(title: NSLocalizedString("Is the user identified?", comment: ""), isUserIdentified: status)
	}

	private func updateConfigurationStatus(status: Bool) {
		items[0] = UserStatusMenuItem(title: NSLocalizedString("Is the DevRev SDK configured?", comment: ""), isUserIdentified: status)
	}

	private func updateMonitoringEnabledStatus(status: Bool) {
		items[2] = UserStatusMenuItem(title: NSLocalizedString("Is session monitoring enabled?", comment: ""), isUserIdentified: status)
	}

	private func checkIdentification() async {
		let isConfigured = await DevRev.isConfigured
		let isUserIdentified = await DevRev.isUserIdentified
		let isMonitoringEnabled = DevRev.isMonitoringEnabled

		updateIdentificationStatus(status: isUserIdentified)
		updateConfigurationStatus(status: isConfigured)
		updateMonitoringEnabledStatus(status: isMonitoringEnabled)

		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.CellIdentifier.main)
		let menuItem = items[indexPath.row]
		cell.textLabel?.text = menuItem.title
		switch menuItem {
		case let item as UserStatusMenuItem:
			cell.imageView?.image = UIImage(systemName: item.isUserIdentified ? "checkmark.square.fill" : "square")
			cell.contentView.alpha = 0.7
			cell.isUserInteractionEnabled = false

		case let item as ActionableMenuItem:
			cell.accessoryType = item.destination != nil ? .disclosureIndicator : .none

		default:
			break
		}
		
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let menuItem = items[indexPath.row]
		guard
			let destinationViewController = (menuItem as? ActionableMenuItem)?.destination
		else {
			return
		}
		
		let viewController = destinationViewController.init()
		navigationController?.pushViewController(viewController, animated: true)
	}
}
