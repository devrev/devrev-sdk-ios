import Foundation
import SwiftUI
import DevRevSDK

struct ContentView: View {
	@SwiftUI.State private var isConfigured = false
	@SwiftUI.State private var isUserIdentified = false
	@SwiftUI.State private var isMonitoringEnabled = false

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Status")) {
					StatusRow(
						status: "Is the SDK configured?",
						isComplete: $isConfigured
					)
					StatusRow(
						status: "Is the user identified?",
						isComplete: $isUserIdentified
					)
					StatusRow(
						status: "Is session monitoring enabled?",
						isComplete: $isMonitoringEnabled
					)
				}

				Section(header: Text("Features")) {
					NavigationLink(destination: IdentificationView()) {
						Text("Identification")
					}
					NavigationLink(destination: PushNotificationsView()) {
						Text("Push Notifications")
					}
					NavigationLink(destination: SupportView()) {
						Text("Support")
					}
					NavigationLink(destination: SessionAnalyticsView()) {
						Text("Session Analytics")
					}
				}
			}
			.navigationTitle("DevRev SDK")
			.navigationBarItems(trailing: RefreshButton(action: updateStatuses))
			.refreshable {
				await updateStatuses()
			}
			.task {
				await updateStatuses()
			}
		}
	}

	private func updateStatuses() async {
		isConfigured = await DevRev.isConfigured
		isUserIdentified = await DevRev.isUserIdentified
		isMonitoringEnabled = DevRev.isMonitoringEnabled
	}
}

#Preview {
	ContentView()
}
