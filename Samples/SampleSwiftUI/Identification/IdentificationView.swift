import Foundation
import SwiftUI
import DevRevSDK

struct IdentificationView: View {
    @SwiftUI.State private var userIdentification = "Not Identified yet"
	
    var body: some View {
        List {
            Text("User ID: \(userIdentification)")
            NavigationLink(destination: UnverifiedUserIdentificationView()) {
                Text("Unverified User Identification")
            }
            NavigationLink(destination: VerifiedUserVerificationView()) {
                Text("Verified User Verification")
            }
        }
        .navigationTitle("Identification")
        .task {
			if await DevRev.isUserIdentified {
				userIdentification = "User Identified"
			}
        }
    }
}
