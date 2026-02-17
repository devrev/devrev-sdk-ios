import Foundation
import UIKit
import DevRevSDK

class IdentificationViewController: UITableViewController {
	private var isUserIdentified = false {
		didSet {
			updateSections()
			tableView.reloadData()
		}
	}

	private var currentUserID: String? {
		get {
			UserDefaults.standard.string(forKey: "currentUserID")
		}

		set {
			guard let newValue
			else {
				UserDefaults.standard.removeObject(forKey: "currentUserID")
				return
			}

			UserDefaults.standard.set(newValue, forKey: "currentUserID")
		}
	}

	private var sections = [[MenuItem]]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Identification", comment: "")

		Task {
			await checkUserIdentification()
		}

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .refresh,
			target: self,
			action: #selector(refresh)
		)

		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Constants.CellIdentifier.identification
		)
		tableView.register(
			UINib(nibName: "StatusTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.status
		)
		tableView.register(
			UINib(nibName: "TextInputTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.textField
		)

		tableView.reloadData()
	}

	private func updateSections() {
		sections = [
			[
				UserStatusMenuItem(
					title: NSLocalizedString("Is the user identified?", comment: ""),
					status: isUserIdentified
				),
			],
			[
				TextFieldMenuItem(
					title: NSLocalizedString("User ID Input", comment: ""),
					placeholder: NSLocalizedString("User ID", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Identify User", comment: "")
				),
			],
			[
				TextFieldMenuItem(
					title: NSLocalizedString("User ID Input", comment: ""),
					placeholder: NSLocalizedString("User ID", comment: "")
				),
				TextFieldMenuItem(
					title: NSLocalizedString("Session Token Input", comment: ""),
					placeholder: NSLocalizedString("Session Token", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Verify User", comment: "")
				),
			],
			[
				TextFieldMenuItem(
					title: NSLocalizedString("Email Input", comment: ""),
					placeholder: NSLocalizedString("New Email", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Update User", comment: "")
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Logout", comment: ""),
					style: .destructive
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
		sections.count
	}

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		sections[section].count
	}

	override func tableView(
		_ tableView: UITableView,
		titleForHeaderInSection section: Int
	) -> String? {
		switch section {
		case 0:
			NSLocalizedString("Status", comment: "")
		case 1:
			NSLocalizedString("Unverified User", comment: "")
		case 2:
			NSLocalizedString("Verified User", comment: "")
		case 3:
			NSLocalizedString("Update User", comment: "")
		case 4:
			NSLocalizedString("Logout", comment: "")
		default:
			nil
		}
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let item = sections[indexPath.section][indexPath.row]

		switch item {
		case let statusItem as UserStatusMenuItem:
			let cell = StatusTableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.status
			)
			cell.configure(with: statusItem.title, status: statusItem.status)
			cell.isUserInteractionEnabled = false

			return cell
		case let textFieldItem as TextFieldMenuItem:
			let cell = TextInputTableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.textField
			)
			cell.configure(with: textFieldItem.placeholder)
			return cell
		case let actionableItem as ActionableMenuItem:
			let cell = UITableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.identification
			)
			configureActionableCell(cell, with: actionableItem)

			return cell
		default:
			return UITableViewCell()
		}
	}

	private func configureActionableCell(
		_ cell: UITableViewCell,
		with item: ActionableMenuItem
	) {
		cell.textLabel?.text = item.title
		cell.accessoryType = .none
		cell.textLabel?.textColor = item.style == .destructive ? .systemRed : .label
	}

	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)

		switch (indexPath.section, indexPath.row) {
		case (1, 1):
			identifyUnverifiedUser()
		case (2, 2):
			verifyUserWithSession()
		case (3, 1):
			updateUser()
		case (4, 0):
			logout()
		default:
			break
		}
	}

	private func identifyUnverifiedUser() {
		guard
			let userIDCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextInputTableViewCell,
			let enteredUserID = userIDCell.text,
			!enteredUserID.isEmpty
		else {
			return
		}

		Task {
			await DevRev.identifyUnverifiedUser(Identity(userID: enteredUserID))
			currentUserID = enteredUserID
			await checkUserIdentification()

			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("User Identify", comment: ""),
				message: NSLocalizedString("User identified as unverified.", comment: "")
			)
		}
	}

	private func verifyUserWithSession() {
		guard
			let userIDCell = tableView.cellForRow(
				at: IndexPath(row: 0, section: 2)
			) as? TextInputTableViewCell,
			let enteredUserID = userIDCell.text,
			!enteredUserID.isEmpty,
			let tokenCell = tableView.cellForRow(
				at: IndexPath(row: 1, section: 2)
			) as? TextInputTableViewCell,
			let enteredSessionToken = tokenCell.text,
			!enteredSessionToken.isEmpty
		else {
			return
		}

		Task {
			await DevRev.identifyVerifiedUser(
				enteredUserID,
				sessionToken: enteredSessionToken
			)
			currentUserID = enteredUserID
			await checkUserIdentification()
			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("User Identify", comment: ""),
				message: NSLocalizedString("User identified as verified.", comment: "")
			)
		}
	}

	private func updateUser() {
		guard
			let emailCell = tableView.cellForRow(
				at: IndexPath(row: 0, section: 3)
			) as? TextInputTableViewCell,
			let email = emailCell.text,
			!email.isEmpty,
			let userID = currentUserID
		else {
			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("Error", comment: ""),
				message: NSLocalizedString("Please identify first", comment: "")
			)
			return
		}

		Task {
			let userTraits = Identity.UserTraits(
				displayName: nil,
				email: email,
				fullName: nil,
				userDescription: nil,
				phoneNumbers: nil,
				customFields: nil
			)

			await DevRev.updateUser(Identity(userID: userID, userTraits: userTraits))
			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("User Update", comment: ""),
				message: NSLocalizedString("User updated successfully.", comment: "")
			)
		}
	}

	private func logout() {
		Task {
			await DevRev.logout(deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "")
			currentUserID = nil
			await checkUserIdentification()
			AlertPresenter.show(
				on: self,
				title: NSLocalizedString("Logout", comment: ""),
				message: NSLocalizedString("The user has been logged out", comment: "")
			)
		}
	}
}
