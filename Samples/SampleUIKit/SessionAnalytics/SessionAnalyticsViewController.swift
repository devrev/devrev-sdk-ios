import UIKit
import DevRevSDK

class SessionAnalyticsViewController: UITableViewController {
	private var sessionItems: [(title: String, items: [MenuItem])] = [
		(
			title: NSLocalizedString("Event Status", comment: ""),
			items: [
				UserStatusMenuItem(title: NSLocalizedString("Are on-demand sessions enabled?", comment: ""), isUserIdentified: false),
				ActionableMenuItem(title: NSLocalizedString("Is the session recorded?", comment: ""), destination: nil)
			]
		),
		(
			title: NSLocalizedString("Track Event", comment: ""),
			items: [
				ActionableMenuItem(title: NSLocalizedString("Stop All Monitoring", comment: ""), destination: nil),
				ActionableMenuItem(title: NSLocalizedString("Resume All Monitoring", comment: ""), destination: nil)
			]
		),
		(
			title: NSLocalizedString("Session Recording", comment: ""),
			items: [
				ActionableMenuItem(title: NSLocalizedString("Start Recording", comment: ""), destination: nil),
				ActionableMenuItem(title: NSLocalizedString("Stop Recording", comment: ""), destination: nil),
				ActionableMenuItem(title: NSLocalizedString("Pause Recording", comment: ""), destination: nil),
				ActionableMenuItem(title: NSLocalizedString("Resume Recording", comment: ""), destination: nil),
				ActionableMenuItem(title: NSLocalizedString("Process All Demand Session", comment: ""), destination: nil)
			]
		)
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		title = NSLocalizedString("Session Analytics", comment: "")
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.sessionAnalytics)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return sessionItems.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sessionItems[section].items.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sessionItems[section].title
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.sessionAnalytics, for: indexPath)
		let sessionItem = sessionItems[indexPath.section].items[indexPath.row]

		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			let statusText = NSLocalizedString("Are on-demand sessions enabled?", comment: "")
			cell.imageView?.image = UIImage(systemName: DevRev.areOnDemandSessionsEnabled ? "checkmark.square.fill" : "square")
			cell.textLabel?.text = statusText
			cell.isUserInteractionEnabled = false
		case (0, 1):
			cell.textLabel?.text = NSLocalizedString("Is the session recorded?", comment: "")
			cell.imageView?.image = UIImage(systemName: DevRev.isRecording ? "checkmark.square.fill" : "square")
			cell.isUserInteractionEnabled = false
		case (2, 4):
			cell.textLabel?.text = sessionItem.title
			cell.isUserInteractionEnabled = DevRev.areOnDemandSessionsEnabled
		default:
			cell.textLabel?.text = sessionItem.title
			cell.selectionStyle = .default
		}

		return cell
	}

	func startRecording() async {
		await DevRev.startRecording()
		updateRecordingStatusRow()
	}

	func startBlinking(_ label: UILabel?) {
		guard
			let label = label
		else {
			return
		}

		label.layer.removeAllAnimations()
		label.alpha = 1.0
		UIView.animate(withDuration: 0.8,
					   delay: 0.0,
					   options: [.autoreverse, .repeat],
					   animations: {
			label.alpha = 0.2
		}, completion: nil)
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
						message: NSLocalizedString("All monitoring activities have been stopped successfully.", comment: "")
					)
				case (1, 1):
					DevRev.resumeAllMonitoring()
					updateRecordingStatusRow()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Monitoring Resumed", comment: ""),
						message: NSLocalizedString("All monitoring activities have resumed.", comment: "")
					)
				case (2, 0):
					await startRecording()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Recording Started", comment: ""),
						message: NSLocalizedString("Session recording is now active.", comment: "")
					)
				case (2, 1):
					DevRev.stopRecording()
					updateRecordingStatusRow()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Recording Stopped", comment: ""),
						message: NSLocalizedString("Session recording has been stopped.", comment: "")
					)
				case (2, 2):
					DevRev.pauseRecording()
					updateRecordingStatusRow()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Recording Paused", comment: ""),
						message: NSLocalizedString("Session recording is now paused and can be resumed later.", comment: "")
					)
				case (2, 3):
					DevRev.resumeRecording()
					updateRecordingStatusRow()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Recording Resumed", comment: ""),
						message: NSLocalizedString("Session recording has resumed.", comment: "")
					)
				case (2, 4):
					DevRev.processAllOnDemandSessions()
					AlertPresenter.show(
						on: self,
						title: NSLocalizedString("Sessions Processed", comment: ""),
						message: NSLocalizedString("All on-demand session recordings have been processed successfully.", comment: "")
					)
				default:
					break
			}
		}
	}

	private func updateRecordingStatusRow() {
		let indexPath = IndexPath(row: 1, section: 0)
		tableView.reloadRows(at: [indexPath], with: .none)
	}
}
