import Foundation
import SwiftUI
import DevRevSDK

struct IdentificationView: View {
	private let title = "Identification"

	@SwiftUI.State private var isUserIdentified = false
	@SwiftUI.State private var unverifiedUserID = ""
	@SwiftUI.State private var verifiedUserID = ""
	@SwiftUI.State private var verifiedSessionToken = ""
	@SwiftUI.State private var email = ""

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

				AsyncButton(text: "Identify the Unverified User") {
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

				AsyncButton(text: "Identify the Unverified User") {
					await DevRev.identifyVerifiedUser(
						verifiedUserID,
						sessionToken: verifiedSessionToken
					)
					await updateStatuses()
				}
			}
			Section(header: Text("Update User")) {
				TextField("New Email", text: $email)
					.autocorrectionDisabled()
					.autocapitalization(.none)
					.keyboardType(.emailAddress)

				AsyncButton(text: "Update the User") {
					await updateUser()
				}
			}
			Section(header: Text("Logout")) {
				AsyncButton(
					text: "Logout",
					role: .destructive
				) {
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

	private func updateUser() async {
		let userID = !verifiedUserID.isEmpty ? verifiedUserID : unverifiedUserID

		let userTraits = Identity.UserTraits(
			displayName: nil,
			email: email.isEmpty ? nil : email,
			fullName: nil,
			userDescription: nil,
			phoneNumbers: nil,
			customFields: nil
		)

		await DevRev.updateUser(Identity(userID: userID, userTraits: userTraits))
	}

	private func updateStatuses() async {
		isUserIdentified = await DevRev.isUserIdentified
	}
}

#Preview {
	IdentificationView()
}
