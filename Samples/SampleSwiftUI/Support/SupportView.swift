import Foundation
import SwiftUI
import DevRevSDK

struct SupportView: View {
	@SwiftUI.State var isSupportVisible = false
	@SwiftUI.State var isUserIdentified = false
	
	var body: some View {
		List{
			Button(action: {
				Task {
					await DevRev.createSupportConversation()
				}
			}) {
				Text("Support Chat")
			}
			.disabled(!isUserIdentified)
			Button(action: { isSupportVisible = true }) {
				Text("Support View")
			}
			.disabled(!isUserIdentified)
			.sheet(isPresented: $isSupportVisible) {
				DevRev.supportView.ignoresSafeArea()
			}
		}
		.task {
			await userIdentified()
		}
	}
	
	private func userIdentified() async
	{
		if await DevRev.isUserIdentified
		{
			isUserIdentified = true
		}
	}
}
