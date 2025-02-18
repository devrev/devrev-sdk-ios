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
				AsyncButton("Resume All Monitoring") {
					DevRev.resumeAllMonitoring()
					await updateStatuses()
				}
				AsyncButton("Stop Monitoring") {
					DevRev.stopAllMonitoring()
					await updateStatuses()
				}
			}
			Section(header: Text("Session Recording")) {
				AsyncButton("Start Recording") {
					await DevRev.startRecording()
					await updateStatuses()
				}
				AsyncButton("Stop Recording") {
					DevRev.stopRecording()
					await updateStatuses()
				}
				AsyncButton("Pause Recording") {
					DevRev.pauseRecording()
					await updateStatuses()
				}
				AsyncButton("Resume Recording") {
					DevRev.resumeRecording()
					await updateStatuses()
				}
			}
			Section(header: Text("On-demand Sessions")) {
				AsyncButton("Process All On-demand Sessions") {
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
