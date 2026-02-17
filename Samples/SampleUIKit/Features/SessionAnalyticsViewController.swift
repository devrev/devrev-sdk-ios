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

	@objc func refresh() {
		tableView.reloadData()
	}
}

private extension SessionAnalyticsViewController {
	func updateSections() {
		sessionItems = [
			createStatusSection(),
			createSessionMonitoringSection(),
			createFeatureConfigurationSection(),
			createSessionRecordingSection(),
			createMediaSection(),
			createTimerSection(),
			createErrorCaptureSection(),
			createManualMaskingSection(),
			createOnDemandSessionsSection(),
			createWebViewSection(),
			createLargeScrollableTableSection(),
		]
	}

	func createStatusSection() -> [MenuItem] {
		[
			UserStatusMenuItem(
				title: NSLocalizedString("Are on-demand sessions enabled?", comment: ""),
				status: areOnDemandSessionsEnabled
			),
			UserStatusMenuItem(
				title: NSLocalizedString("Is the session recorded?", comment: ""),
				status: isRecording
			),
		]
	}

	func createSessionMonitoringSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Stop Monitoring", comment: "")
			),
			ActionableMenuItem(
				title: NSLocalizedString("Resume All Monitoring", comment: "")
			),
		]
	}

	func createFeatureConfigurationSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Disable Frame Capture", comment: "")
			),
			ActionableMenuItem(
				title: NSLocalizedString("Update Support Widget Theme", comment: "")
			),
		]
	}

	func createSessionRecordingSection() -> [MenuItem] {
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
			ActionableMenuItem(
				title: NSLocalizedString("Pause User Interaction Tracking", comment: "")
			),
			ActionableMenuItem(
				title: NSLocalizedString("Resume User Interaction Tracking", comment: "")
			),
		]
	}

	func createMediaSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Camera", comment: ""),
				destination: CameraViewController.self
			),
			ActionableMenuItem(
				title: NSLocalizedString("Gallery", comment: ""),
				destination: GalleryViewController.self
			),
		]
	}

	func createTimerSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Start Timer", comment: "")
			),
			ActionableMenuItem(
				title: NSLocalizedString("End Timer", comment: "")
			),
		]
	}

	func createErrorCaptureSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Capture Error", comment: ""),
				icon: "exclamationmark.circle",
				iconColor: .systemYellow
			),
		]
	}

	func createManualMaskingSection() -> [MenuItem] {
		[
			ManuallyMaskedMenuItem(
				title: NSLocalizedString("Manually Masked UI Item", comment: "")
			),
			TextFieldMenuItem(
				title: NSLocalizedString("Manually Unmasked UI Item", comment: ""),
				placeholder: NSLocalizedString("Manually Unmasked UI Item", comment: "")
			),
		]
	}

	func createOnDemandSessionsSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Process All On-demand Sessions", comment: "")
			),
		]
	}

	func createWebViewSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Open Web View", comment: ""),
				destination: MaskedWebViewViewController.self
			),
		]
	}

	func createLargeScrollableTableSection() -> [MenuItem] {
		[
			ActionableMenuItem(
				title: NSLocalizedString("Open Large Scrollable Table", comment: ""),
				destination: TableViewViewController.self
			),
		]
	}
}

extension SessionAnalyticsViewController {
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
			NSLocalizedString("Feature Configuration", comment: "")
		case 3:
			NSLocalizedString("Session Recording", comment: "")
		case 4:
			NSLocalizedString("Media", comment: "")
		case 5:
			NSLocalizedString("Timer", comment: "")
		case 6:
			NSLocalizedString("Error Capture", comment: "")
		case 7:
			NSLocalizedString("Manual Masking / Unmasking", comment: "")
		case 8:
			NSLocalizedString("On-demand Sessions", comment: "")
		case 9:
			NSLocalizedString("Web View", comment: "")
		case 10:
			NSLocalizedString("Large Scrollable Table", comment: "")
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
			if let iconColor = actionableItem.iconColor {
				cell.textLabel?.textColor = iconColor
			}
			else {
				cell.textLabel?.textColor = .label
			}
			if let iconName = actionableItem.icon {
				let iconImageView = UIImageView(image: UIImage(systemName: iconName))
				iconImageView.tintColor = actionableItem.iconColor ?? .label
				cell.accessoryView = iconImageView
				cell.accessoryType = .none
			}
			else {
				cell.accessoryView = nil
				cell.accessoryType = actionableItem.destination != nil ? .disclosureIndicator : .none
			}

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
			await handleCellSelection(at: indexPath)
		}

		navigateToDestinationIfNeeded(at: indexPath)
	}

	func handleCellSelection(at indexPath: IndexPath) async {
		switch (indexPath.section, indexPath.row) {
		case (1, 0):
			handleStopMonitoring()
		case (1, 1):
			handleResumeAllMonitoring()
		case (2, 0):
			disableFrameCapture()
		case (2, 1):
			updateSupportWidgetTheme()
		case (3, 0):
			await handleStartRecording()
		case (3, 1):
			handleStopRecording()
		case (3, 2):
			handlePauseRecording()
		case (3, 3):
			handleResumeRecording()
		case (3, 4):
			handlePauseUserInteractionTracking()
		case (3, 5):
			handleResumeUserInteractionTracking()
		case (5, 0):
			handleStartTimer()
		case (5, 1):
			handleEndTimer()
		case (6, 0):
			handleCaptureError()
		case (8, 0):
			handleProcessOnDemandSessions()
		default:
			break
		}
	}

	func navigateToDestinationIfNeeded(at indexPath: IndexPath) {
		let item = sessionItems[indexPath.section][indexPath.row]
		guard let destinationViewController = (item as? ActionableMenuItem)?.destination else {
			return
		}

		let viewController = destinationViewController.init()
		navigationController?.pushViewController(viewController, animated: true)
	}
}

private extension SessionAnalyticsViewController {
	func updateRecordingStatusRow() {
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

	func captureTestError() {
		let error = NSError(
			domain: "ai.devrev.sdk.sample.uikit",
			code: 1001,
			userInfo: [
				NSLocalizedDescriptionKey: "This is a test error!"
			]
		)

		DevRev.captureError(error, tag: "TestError")
	}

	func handleResumeAllMonitoring() {
		DevRev.resumeAllMonitoring()
		updateRecordingStatusRow()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Monitoring Resumed", comment: ""),
			message: NSLocalizedString("All monitoring activities have resumed.", comment: "")
		)
	}

	func handleStopMonitoring() {
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
	}

	func disableFrameCapture() {
		DevRev.updateFeatureConfiguration(
			.init(
				withShouldEnableFrameCapture: false
			)
		)

		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Configuration Updated", comment: ""),
			message: NSLocalizedString(
				"Frame capture is now disabled!",
				comment: ""
			)
		)
	}

	func updateSupportWidgetTheme() {
		let theme = SupportWidgetTheme(
			prefersSystemTheme: false,
			primaryTextColor: "#1F2933",
			accentColor: "#F97316",
			spacing: ["bottom": "20px", "side": "16px"]
		)

		DevRev.updateFeatureConfiguration(
			.init(witCustomSupportWidgetTheme: theme)
		)

		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Configuration Updated", comment: ""),
			message: NSLocalizedString(
				"Support widget theme updated with custom values: (primary text color: #1F2933, accent color: #F97316, spacing: 20px bottom, 16px side)!",
				comment: ""
			)
		)
	}

	func handleStartRecording() async {
		await startRecording()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Recording Started", comment: ""),
			message: NSLocalizedString("Session recording is now active.", comment: "")
		)
	}

	func handleStopRecording() {
		DevRev.stopRecording()
		updateRecordingStatusRow()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Recording Stopped", comment: ""),
			message: NSLocalizedString("Session recording has been stopped.", comment: "")
		)
	}

	func handlePauseRecording() {
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
	}

	func handleResumeRecording() {
		DevRev.resumeRecording()
		updateRecordingStatusRow()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Recording Resumed", comment: ""),
			message: NSLocalizedString("Session recording has resumed.", comment: "")
		)
	}

	func handlePauseUserInteractionTracking() {
		DevRev.pauseUserInteractionTracking()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("User Interaction Tracking Paused", comment: ""),
			message: NSLocalizedString("User interaction tracking has paused.", comment: "")
		)
	}

	func handleResumeUserInteractionTracking() {
		DevRev.resumeUserInteractionTracking()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("User Interaction Tracking Resumed", comment: ""),
			message: NSLocalizedString("User interaction tracking has resumed.", comment: "")
		)
	}

	func handleStartTimer() {
		let property: [String: String] = ["test-key1": "test-value1"]
		DevRev.startTimer("test-event", properties: property)
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Timer Started", comment: ""),
			message: NSLocalizedString("Timer with session property started.", comment: "")
		)
	}

	func handleEndTimer() {
		let property: [String: String] = ["test-key2": "test-value2"]
		DevRev.endTimer("test-event", properties: property)
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Timer Ended", comment: ""),
			message: NSLocalizedString("Timer with session property stopped.", comment: "")
		)
	}

	func handleCaptureError() {
		captureTestError()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Error Captured", comment: ""),
			message: NSLocalizedString("Test error has been captured and sent to SDK.", comment: "")
		)
	}

	func handleProcessOnDemandSessions() {
		DevRev.processAllOnDemandSessions()
		AlertPresenter.show(
			on: self,
			title: NSLocalizedString("Sessions Processed", comment: ""),
			message: NSLocalizedString(
				"All on-demand session recordings have been processed successfully.",
				comment: ""
			)
		)
	}
}
