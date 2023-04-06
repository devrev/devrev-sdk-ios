import SwiftUI
import DevRevSDK

struct ContentView: View {
	@State private var isSupportVisible = false
	@State private var isUserIdentified = false
	@State private var userID: String = ""

	#error("The sample app needs a development team set for code signing.")
	#error("Enter your credentials and organization slug here!")
	private let appID = "<APPID>"
	private let secret = "<SECRET>"
	private let organizationSlug = "<SLUG>"

	init() {
		DevRev.configure(appID: appID,
						 secret: secret,
						 organizationSlug: organizationSlug)
	}

	var body: some View {
		VStack {
			TextField("User ID", text: $userID)
				.padding()
				.textFieldStyle(RoundedBorderTextFieldStyle())
				.autocorrectionDisabled()
				.autocapitalization(.none)

			Button("Identify the user") {
				Task {
					await DevRev.identify(Identification(userID: userID))
					isUserIdentified = DevRev.isInitialized
				}
			}
			.disabled(userID.isEmpty)
			.modifier(ButtonModifier())


			Button("Show the support view") {
				isSupportVisible = true
			}
			.disabled(isUserIdentified == false)
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
			.font(.title2)
			.buttonBorderShape(.capsule)
			.buttonStyle(.borderedProminent)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
