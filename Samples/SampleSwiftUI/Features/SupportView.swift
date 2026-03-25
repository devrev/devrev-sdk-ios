import Foundation
import SwiftUI
import DevRevSDK

struct SupportView: View {
	private let title = "Support"

	@SwiftUI.State var isSupportVisible = false
	@SwiftUI.State var isUserIdentified = false

	var body: some View {
		List {
			Section(header: Text("Status")) {
				StatusRow(
					status: "Is the user identified?",
					isComplete: $isUserIdentified
				)
				.accessibilityIdentifier(TestConstants.AccessibilityID.Support.userIdentifiedStatus)
			}
			Section(header: Text("Support Chat")) {
				AsyncButton(text: "Create a new conversation") {
					await DevRev.createSupportConversation()
					await updateStatuses()
				}
				.disabled(!isUserIdentified)
				.accessibilityIdentifier(TestConstants.AccessibilityID.Support.createConversationButton)

				AsyncButton(text: "Show the support chat") {
					isSupportVisible = true
					await updateStatuses()
				}
				.disabled(!isUserIdentified)
				.sheet(isPresented: $isSupportVisible) {
					DevRev.supportView.ignoresSafeArea()
				}
				.accessibilityIdentifier(TestConstants.AccessibilityID.Support.showSupportButton)
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
		isUserIdentified = await DevRev.isUserIdentified
	}
}
