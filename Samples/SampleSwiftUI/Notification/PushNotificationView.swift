import Foundation
import SwiftUI
import DevRevSDK

struct PushNotificationView: View {
    @SwiftUI.State private var showAlert = false
    @SwiftUI.State private var alertTitle = ""
    @SwiftUI.State private var alertMessage = ""

    var body: some View {
        List {
            Button(action: {
                UIApplication.shared.registerForRemoteNotifications()
                showAlert(title: "Registered", message: "You have successfully registered for push notifications.")
            }) {
                Text("Register for Push Notifications")
            }
            Button(action: {
                UIApplication.shared.unregisterForRemoteNotifications()
                Task {
					guard
						let deviceID = UIDevice.current.identifierForVendor?.uuidString
					else {
						return
					}
					
                    await DevRev.unregisterDevice(deviceID)
                    showAlert(title: "Unregistered", message: "You have successfully unregistered from push notifications.")
                }
            }) {
                Text("Unregister from Push Notifications")
            }
        }
        .navigationTitle("Push Notifications")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
