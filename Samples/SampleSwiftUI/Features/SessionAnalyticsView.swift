import Foundation
import SwiftUI
import DevRevSDK

struct SessionAnalyticsView: View {
	private let title = "Session Analytics"

	@SwiftUI.State private var isMonitoringEnabled = false
	@SwiftUI.State private var isRecording = false

	var body: some View {
		List {
			Section(header: Text("Status")) {
				StatusRow(
					status: "Is session monitoring enabled?",
					isComplete: $isMonitoringEnabled
				)
				StatusRow(
					status: "Is the session recorded?",
					isComplete: $isRecording
				)
			}
			Section(header: Text("Session Monitoring")) {
				AsyncButton(text: "Resume All Monitoring") {
					DevRev.resumeAllMonitoring()
					await updateStatuses()
				}
				AsyncButton(text: "Stop Monitoring") {
					DevRev.stopAllMonitoring()
					await updateStatuses()
				}
			}
			Section(header: Text("Session Recording")) {
				AsyncButton(text: "Start Recording") {
					await DevRev.startRecording()
					await updateStatuses()
				}
				AsyncButton(text: "Stop Recording") {
					DevRev.stopRecording()
					await updateStatuses()
				}
				AsyncButton(text: "Pause Recording") {
					DevRev.pauseRecording()
					await updateStatuses()
				}
				AsyncButton(text: "Resume Recording") {
					DevRev.resumeRecording()
					await updateStatuses()
				}
			}
			Section(header: Text("Timer")) {
				AsyncButton(text: "Start Timer") {
					let property: [String: String] = ["test-key1": "test-value1"]
					DevRev.startTimer("test-event", properties: property)
					await updateStatuses()
				}
				AsyncButton(text: "Stop Timer") {
					let property: [String: String] = ["test-key2": "test-value2"]
					DevRev.endTimer("test-event", properties: property)
					await updateStatuses()
				}
			}
			Section(header: Text("Manual Masking / Unmasking")) {
				MaskedLabelView(text: "Manually Masked UI Item")
				UnmaskedTextFieldView(placeholder: "Manually Unmasked UI Item")
			}
			Section(header: Text("On-demand Sessions")) {
				AsyncButton(text: "Process All On-demand Sessions") {
					DevRev.processAllOnDemandSessions()
					await updateStatuses()
				}
			}
		}
		.navigationTitle(title)
		.navigationBarItems(trailing: RefreshButton(action: updateStatuses))
		.refreshable {
			await updateStatuses()
		}
		.task {
			await updateStatuses()
		}
	}

	private func updateStatuses() async {
		isRecording = DevRev.isRecording
		isMonitoringEnabled = DevRev.isMonitoringEnabled
	}
}

struct MaskedLabelView: UIViewRepresentable {
	let text: String

	func makeUIView(context: Context) -> UILabel {
		let label = UILabel()
		label.text = text
		return label
	}

	func updateUIView(_ uiView: UILabel, context: Context) {
		uiView.text = text
		DevRev.markSensitiveViews([uiView])
	}
}

struct UnmaskedTextFieldView: UIViewRepresentable {
	let placeholder: String

	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		return textField
	}

	func updateUIView(_ uiView: UITextField, context: Context) {
		DevRev.unmarkSensitiveViews([uiView])
	}
}
