import Foundation
import UIKit
import DevRevSDK

class SessionAnalyticsViewController: UITableViewController {
	private var areOnDemandSessionsEnabled = false {
		didSet {
			tableView.reloadData()
		}
	}

	private var isRecording = false {
		didSet {
			tableView.reloadData()
		}
	}

	private var sessionItems = [[MenuItem]]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Session Analytics", comment: "")
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .refresh,
			target: self,
			action: #selector(refresh)
		)

		updateSections()

		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Constants.CellIdentifier.sessionAnalytics
		)
		tableView.register(
			UINib(nibName: "StatusTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.status
		)
		tableView.register(
			UINib(nibName: "TextInputTableViewCell", bundle: nil),
			forCellReuseIdentifier: Constants.CellIdentifier.textField
		)

		DevRev.addSessionProperties( ["test_user_id": "test_001"])
		tableView.reloadData()
	}

	private func updateSections() {
		sessionItems = [
			[
				UserStatusMenuItem(
					title: NSLocalizedString("Are on-demand sessions enabled?", comment: ""),
					status: areOnDemandSessionsEnabled
				),
				UserStatusMenuItem(
					title: NSLocalizedString("Is the session recorded?", comment: ""),
					status: isRecording
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Stop All Monitoring", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Resume All Monitoring", comment: "")
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Start Recording", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Stop Recording", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Pause Recording", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("Resume Recording", comment: "")
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Start Timer", comment: "")
				),
				ActionableMenuItem(
					title: NSLocalizedString("End Timer", comment: "")
				),
			],
			[
				ManuallyMaskedMenuItem(
					title: NSLocalizedString("Manually Masked UI Item", comment: "")
				),
				TextFieldMenuItem(
					title: NSLocalizedString("Manually Unmasked UI Item", comment: ""),
					placeholder: NSLocalizedString("Manuallly Unmasked UI Item", comment: "")
				),
			],
			[
				ActionableMenuItem(
					title: NSLocalizedString("Process All Demand Sessions", comment: "")
				),
			],
		]
	}

	@objc func refresh() {
		updateRecordingStatusRow()
	}

	override func numberOfSections(
		in tableView: UITableView
	) -> Int {
		sessionItems.count
	}

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		sessionItems[section].count
	}

	override func tableView(
		_ tableView: UITableView,
		titleForHeaderInSection section: Int
	) -> String? {
		switch section {
		case 0:
			NSLocalizedString("Status", comment: "")
		case 1:
			NSLocalizedString("Session Monitoring", comment: "")
		case 2:
			NSLocalizedString("Session Recording", comment: "")
		case 3:
			NSLocalizedString("Timer", comment: "")
		case 4:
			NSLocalizedString("Manual Masking / Unmasking", comment: "")
		case 5:
			NSLocalizedString("On-demand Sessions", comment: "")
		default:
			nil
		}
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let item = sessionItems[indexPath.section][indexPath.row]

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
		case let actionableItem as ActionableMenuItem:
			let cell = UITableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.sessionAnalytics
			)
			cell.textLabel?.text = actionableItem.title
			return cell
		case let maskedItem as ManuallyMaskedMenuItem:
			let cell = UITableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.sessionAnalytics
			)
			cell.textLabel?.text = maskedItem.title
			DevRev.markSensitiveViews([cell])
			cell.selectionStyle = .none
			return cell
		case let textFieldItem as TextFieldMenuItem:
			let cell = TextInputTableViewCell.dequeue(
				from: tableView,
				at: indexPath,
				reuseIdentifier: Constants.CellIdentifier.textField
			)
			cell.configure(with: textFieldItem.placeholder)
			DevRev.unmarkSensitiveViews([cell.textField])
			cell.selectionStyle = .none
			return cell
		default:
			return UITableViewCell()
		}
	}

	func startRecording() async {
		await DevRev.startRecording()
		updateRecordingStatusRow()
	}

	// swiftlint:disable function_body_length
	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)

		guard
			indexPath.section != 0 || indexPath.row != 0
		else {
			return
		}

		Task {
			switch (indexPath.section, indexPath.row) {
			case (1, 0):
				DevRev.stopAllMonitoring()
				updateRecordingStatusRow()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Monitoring Stopped", comment: ""),
					message: NSLocalizedString(
						"All monitoring activities have been stopped successfully.",
						comment: ""
					)
				)
			case (1, 1):
				DevRev.resumeAllMonitoring()
				updateRecordingStatusRow()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Monitoring Resumed", comment: ""),
					message: NSLocalizedString(
						"All monitoring activities have resumed.",
						comment: ""
					)
				)
			case (2, 0):
				await startRecording()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Recording Started", comment: ""),
					message: NSLocalizedString(
						"Session recording is now active.",
						comment: ""
					)
				)
			case (2, 1):
				DevRev.stopRecording()
				updateRecordingStatusRow()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Recording Stopped", comment: ""),
					message: NSLocalizedString(
						"Session recording has been stopped.",
						comment: ""
					)
				)
			case (2, 2):
				DevRev.pauseRecording()
				updateRecordingStatusRow()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Recording Paused", comment: ""),
					message: NSLocalizedString(
						"Session recording is now paused and can be resumed later.",
						comment: ""
					)
				)
			case (2, 3):
				DevRev.resumeRecording()
				updateRecordingStatusRow()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Recording Resumed", comment: ""),
					message: NSLocalizedString(
						"Session recording has resumed.",
						comment: ""
					)
				)
			case (3, 0):
				let property: [String: String] = ["test-key1": "test-value1"]
				DevRev.startTimer("test-event", properties: property)
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Timer Started", comment: ""),
					message: NSLocalizedString("Timer with session property started.", comment: "")
				)
			case (3, 1):
				let property: [String: String] = ["test-key2": "test-value2"]
				DevRev.endTimer("test-event", properties: property)
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Timer Ended", comment: ""),
					message: NSLocalizedString("Timer with session property stopped.", comment: "")
				)
			case (5, 0):
				DevRev.processAllOnDemandSessions()
				AlertPresenter.show(
					on: self,
					title: NSLocalizedString("Sessions Processed", comment: ""),
					message: NSLocalizedString(
						"All on-demand session recordings have been processed successfully.",
						comment: ""
					)
				)
			default:
				break
			}
		}
	}
	// swiftlint:enable function_body_length

	private func updateRecordingStatusRow() {
		self.areOnDemandSessionsEnabled = DevRev.areOnDemandSessionsEnabled
		self.isRecording = DevRev.isRecording

		sessionItems[0][0] = UserStatusMenuItem(
			title: NSLocalizedString(
				"Are on-demand sessions enabled?",
				comment: ""
			),
			status: areOnDemandSessionsEnabled
		)
		sessionItems[0][1] = UserStatusMenuItem(
			title: NSLocalizedString(
				"Is the session recorded?",
				comment: ""
			),
			status: isRecording
		)

		tableView.reloadRows(
			at: [
				IndexPath(row: 0, section: 0),
				IndexPath(row: 1, section: 0),
			],
			with: .none
		)
	}
}
