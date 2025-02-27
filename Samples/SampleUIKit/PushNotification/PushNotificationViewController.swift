import Foundation
import UIKit
import DevRevSDK

class PushNotificationViewController: UITableViewController {
	private var items: [ActionableMenuItem] = [
		.init(title: NSLocalizedString("Register for Push Notifications", comment: ""), destination: nil),
		.init(title: NSLocalizedString("Unregister from Push Notifications", comment: ""), destination: nil)
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		title = NSLocalizedString("Push Notifications", comment: "")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.pushNotifications)
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.pushNotifications, for: indexPath)
		cell.textLabel?.text = items[indexPath.row].title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch indexPath.row {
		case 0:
			registerForPushNotifications()
		case 1:
			unregisterFromPushNotifications()
		default:
			break
		}
	}

	private func registerForPushNotifications() {
		UIApplication.shared.registerForRemoteNotifications()
		AlertPresenter
			.show(
				on: self,
				title: NSLocalizedString("Registered", comment: ""),
				message: NSLocalizedString("You have successfully registered for push notifications.", comment: "")
			)
	}

	private func unregisterFromPushNotifications() {
		UIApplication.shared.unregisterForRemoteNotifications()
		Task {
			guard
				let deviceID = UIDevice.current.identifierForVendor?.uuidString
			else {
				return
			}

			await DevRev.unregisterDevice(deviceID)

			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("Unregistered", comment: ""),
				message: NSLocalizedString("You have successfully unregistered from push notifications.", comment: "")
			)
		}
	}
}
