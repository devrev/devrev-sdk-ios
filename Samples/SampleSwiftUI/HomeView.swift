import Foundation
import SwiftUI
import DevRevSDK

struct HomeView: View {
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
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.sdkConfiguredStatus)
					StatusRow(
						status: "Is the user identified?",
						isComplete: $isUserIdentified
					)
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.userIdentifiedStatus)
					StatusRow(
						status: "Is session monitoring enabled?",
						isComplete: $isMonitoringEnabled
					)
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.monitoringEnabledStatus)
				}

				Section(header: Text("Features")) {
					NavigationLink(destination: IdentificationView()) {
						Text("Identification")
					}
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.identificationLink)
					NavigationLink(destination: PushNotificationsView()) {
						Text("Push Notifications")
					}
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.pushNotificationsLink)
					NavigationLink(destination: SupportView()) {
						Text("Support")
					}
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.supportLink)
					NavigationLink(destination: SessionAnalyticsView()) {
						Text("Session Analytics")
					}
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.sessionAnalyticsLink)
				}

				Section(header: Text("Debug")) {
					Button(
						role: .destructive,
						action: {
							print("The app will crash now!")
							let array = [Int]()
							_ = array[1]
						}
					) {
						HStack {
							Text("Force a crash")
							Spacer()
							Image(systemName: "exclamationmark.triangle.fill")
						}
					}
					.accessibilityIdentifier(TestConstants.AccessibilityID.Home.forceCrashButton)
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
	HomeView()
}
