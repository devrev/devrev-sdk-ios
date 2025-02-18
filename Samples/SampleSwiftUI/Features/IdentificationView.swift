import Foundation
import SwiftUI
import DevRevSDK

struct IdentificationView: View {
	private let title = "Identification"

	@SwiftUI.State private var isUserIdentified = false
	@SwiftUI.State private var unverifiedUserID = ""
	@SwiftUI.State private var verifiedUserID = ""
	@SwiftUI.State private var verifiedSessionToken = ""

	var body: some View {
		List {
			Section(header: Text("Status")) {
				StatusRow(
					status: "Is the user identified?",
					isComplete: $isUserIdentified
				)
			}
			Section(header: Text("Unverified User")) {
				TextField("User ID", text: $unverifiedUserID)
						.autocorrectionDisabled()
						.autocapitalization(.none)

				AsyncButton("Identify the Unverified User") {
					await DevRev.identifyUnverifiedUser(
						.init(userID: unverifiedUserID)
					)
					await updateStatuses()
				}
			}
			Section(header: Text("Verified User")) {
				TextField("User ID", text: $verifiedUserID)
						.autocorrectionDisabled()
						.autocapitalization(.none)

				TextField("Session Token", text: $verifiedSessionToken)
						.autocorrectionDisabled()
						.autocapitalization(.none)

				AsyncButton("Identify the Unverified User") {
					await DevRev.identifyVerifiedUser(
						verifiedUserID,
						sessionToken: verifiedSessionToken
					)
					await updateStatuses()
				}
			}
			Section(header: Text("Logout")) {
				AsyncButton("Logout") {
					await DevRev.logout(deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "")
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
		isUserIdentified = await DevRev.isUserIdentified
	}
}

#Preview {
	IdentificationView()
}
