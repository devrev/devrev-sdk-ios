import Foundation
import UIKit
import DevRevSDK

class HomeViewController: UITableViewController {
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
	private var isMonitoringEnabled = false {
		didSet {
			tableView.reloadData()
		}
	}

	private var items: [[MenuItem]] {
		[
			[
				UserStatusMenuItem(
					title: NSLocalizedString("Is the DevRev SDK configured?", comment: ""),
					status: isConfigured
				),
				UserStatusMenuItem(
					title: NSLocalizedString("Is the user identified?", comment: ""),
					status: isUserIdentified
				),
				UserStatusMenuItem(
					title: NSLocalizedString("Is session monitoring enabled?", comment: ""),
					status: isMonitoringEnabled
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Identification", comment: ""),
					destination: IdentificationViewController.self
				),
				ActionableMenuItem(
					title: NSLocalizedString("Push Notification", comment: ""),
					destination: PushNotificationViewController.self
				),
				ActionableMenuItem(
					title: NSLocalizedString("Support", comment: ""),
					destination: SupportViewController.self
				),
				ActionableMenuItem(
					title: NSLocalizedString("Session Analytics", comment: ""),
					destination: SessionAnalyticsViewController.self
				)
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Force a crash", comment: ""),
					style: .destructive
				)
			],
		]
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("DevRev SDK", comment: "")
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .refresh,
			target: self,
			action: #selector(refresh)
		)

		Task {
			await checkIdentification()
		}

		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Constants.CellIdentifier.main
		)
		tableView.register(
			UINib(nibName: "StatusTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.status
		)

		tableView.reloadData()
	}

	@objc func refresh() {
		Task {
			await checkIdentification()
		}
	}

	private func checkIdentification() async {
		isConfigured = await DevRev.isConfigured
		isUserIdentified = await DevRev.isUserIdentified
		isMonitoringEnabled = DevRev.isMonitoringEnabled
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		items.count
	}

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		items[section].count
	}

	override func tableView(
		_ tableView: UITableView,
		titleForHeaderInSection section: Int
	) -> String? {
		switch section {
		case 0:
			NSLocalizedString("Status", comment: "")
		case 1:
			NSLocalizedString("Features", comment: "")
		case 2:
			NSLocalizedString("Debug", comment: "")
		default:
			nil
		}
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let menuItem = items[indexPath.section][indexPath.row]

		switch menuItem {
		case let item as UserStatusMenuItem:
			let cell = StatusTableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.status
			)
			cell.configure(with: item.title, status: item.status)
			cell.isUserInteractionEnabled = false

			return cell
		case let item as ActionableMenuItem:
			let cell = UITableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.main
			)
			cell.textLabel?.text = item.title
			cell.accessoryType = item.destination != nil ? .disclosureIndicator : .none
			cell.textLabel?.textColor = item.style == .destructive ? .systemRed : .label

			return cell
		default:
			return UITableViewCell()
		}
	}

	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		switch (indexPath.section, indexPath.row) {
		case (2, 0):
			forceCrash()
		default:
			break
		}

		let menuItem = items[indexPath.section][indexPath.row]
		guard
			let destinationViewController = (menuItem as? ActionableMenuItem)?.destination
		else {
			return
		}

		let viewController = destinationViewController.init(style: .insetGrouped)
		navigationController?.pushViewController(viewController, animated: true)
	}

	private func forceCrash() {
		print("The app will crash now!")
		let array = [Int]()
		_ = array[1]
	}
}
