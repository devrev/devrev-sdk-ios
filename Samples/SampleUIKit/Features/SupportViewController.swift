import Foundation
import UIKit
import DevRevSDK

class SupportViewController: UITableViewController {
	private var isSupportVisible = false
	private var isUserIdentified = false {
		didSet {
			updateSections()
			tableView.reloadData()
		}
	}

	private var items = [[MenuItem]]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Support", comment: "")

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .refresh,
			target: self,
			action: #selector(refresh)
		)

		Task {
			await checkUserIdentification()
		}

		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Constants.CellIdentifier.support
		)
		tableView.register(
			UINib(nibName: "StatusTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.status
		)

		tableView.reloadData()
	}

	private func updateSections() {
		items = [
			[
				UserStatusMenuItem(
					title: NSLocalizedString("Is the user identified?", comment: ""),
					status: isUserIdentified
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Support Chat", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Support View", comment: "")
				),
			],
		]
	}

	@objc func refresh() {
		Task {
			await checkUserIdentification()
		}
	}

	private func checkUserIdentification() async {
		isUserIdentified = await DevRev.isUserIdentified
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
			return NSLocalizedString("User Status", comment: "")
		case 1:
			return NSLocalizedString("Support Options", comment: "")
		default:
			return nil
		}
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let supportItem = items[indexPath.section][indexPath.row]

		switch supportItem {
		case let statusItem as UserStatusMenuItem:
			let cell = StatusTableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.status
			)
			cell.configure(with: statusItem.title, status: statusItem.status)
			cell.isUserInteractionEnabled = false

			return cell
		case let actionableItem as ActionableMenuItem:
			let cell = UITableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.support
			)
			cell.textLabel?.text = actionableItem.title

			return cell
		default:
			return UITableViewCell()
		}
	}

	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch (indexPath.section, indexPath.row) {
		case (1, 0):
			createSupportConversation()
		case (1, 1):
			showSupport()
		default:
			break
		}
	}

	private func createSupportConversation() {
		Task {
			await DevRev.createSupportConversation()
		}
	}

	@IBAction func showSupport() {
		Task {
			await DevRev.showSupport(isAnimated: true)
		}
	}
}
