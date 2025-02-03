import Foundation
import SwiftUI
import DevRevSDK

struct UnverifiedUserIdentificationView: View {
    @SwiftUI.State private var userID = ""
    @SwiftUI.State private var isUserIdentified = false
    @SwiftUI.State private var showAlert = false
    @SwiftUI.State private var isSupportVisible = false

    var body: some View {
        List {
            Section(header: Text("User Identification")) {
                TextField("Enter User ID", text: $userID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 8)
                
                Button("Identify the Unverified User") {
					Task {
						isUserIdentified = await DevRev.isUserIdentified
						guard
							isUserIdentified
						else {
							return
						}
						
						showAlert = true
					}
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Unverified User Identification")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("The user has been successfully identified."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
