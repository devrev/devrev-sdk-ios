import SwiftUI

struct RefreshButton: View {
	let action: () async -> Void

	var body: some View {
		Button(action: {
			Task {
				await action()
			}
		}) {
			Image(systemName: "arrow.clockwise")
		}
	}
}

#Preview {
	RefreshButton(
		action: {
			print("Refreshing")
		}
	)
}
