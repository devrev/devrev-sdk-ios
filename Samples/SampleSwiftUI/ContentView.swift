import Foundation
import SwiftUI
import DevRevSDK

struct ContentView: View {
	@SwiftUI.State private var isUserConfigured = true
	@SwiftUI.State private var isUserIdentified = false
	
	var body: some View {
		NavigationView {
			List {
				HStack{
					Image(systemName: isUserConfigured ? "checkmark.square.fill" : "square")
					Text("Configured")
				}
				HStack{
					Image(systemName: isUserIdentified ? "checkmark.square.fill" : "square")
					Text("Identified")
				}
				NavigationLink(destination: IdentificationView()) {
					Text("Identification")
				}
				NavigationLink(destination: PushNotificationView()) {
					Text("Push Notification")
				}
				NavigationLink(destination: SupportView()) {
					Text("Support")
				}
				.buttonStyle(PlainButtonStyle())
				NavigationLink(destination: SessionAnalyticsView()) {
					Text("Session Analytics")
				}
			}
			.navigationTitle("Main Menu")
			.task {
				await checkIdentification()
			}
		}
	}
	private func checkIdentification() async
	{
		let isUserIdentified = await DevRev.isUserIdentified
				
		await MainActor.run {
			self.isUserIdentified = isUserIdentified
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
