import Foundation
import SwiftUI
import DevRevSDK

struct VerifiedUserVerificationView : View {
    @SwiftUI.State private var userId = ""
    @SwiftUI.State private var sessionToken = ""
    
    var body: some View {
        List{
            TextField("User Id", text: $userId)
            TextField("Session Token", text: $sessionToken)
            Button(action: {
                Task {
                    await DevRev.identifyVerifiedUser(userId, sessionToken: sessionToken)
                }
            }) {
                Text("Verified User Identification")
            }
        }
        .navigationTitle("Verified User Identification")
    }
}
