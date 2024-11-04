import Foundation
import SwiftUI
import DevRevSDK

struct ContentView: View {
	@SwiftUI.State private var isSupportVisible = false
	@SwiftUI.State private var isUserIdentified = false
	@SwiftUI.State private var userID: String = ""

	var body: some View {
		VStack {
			TextField("User ID", text: $userID)
				.padding()
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.autocorrectionDisabled()
				.autocapitalization(.none)

			Button("Identify the unverified user") {
				Task {
					await DevRev.identifyUnverifiedUser(Identity(userID: userID))

					isUserIdentified = await DevRev.isUserIdentified
				}
			}
			.disabled(userID.isEmpty)
			.modifier(ButtonModifier())

			Button("Show the support view") {
				isSupportVisible = true
			}
			.disabled(isUserIdentified == false)
			.modifier(ButtonModifier())

			Button("Register for push notifications") {
				UIApplication.shared.registerForRemoteNotifications()
			}
			.modifier(ButtonModifier())

			Button("Unregister from push notifications") {
				UIApplication.shared.unregisterForRemoteNotifications()

				Task {
					guard
						let deviceID = UIDevice.current.identifierForVendor?.uuidString
					else {
						return
					}

					await DevRev.unregisterDevice(deviceID)
				}
			}
			.modifier(ButtonModifier())
		}
		.sheet(isPresented: $isSupportVisible) {
			DevRev.supportView.ignoresSafeArea()
		}
		.padding()
	}
}

struct ButtonModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.buttonBorderShape(.capsule)
			.buttonStyle(.borderedProminent)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
