import SwiftUI

struct RefreshButton: View {
	let action: () async -> Void

	var body: some View {
		AsyncButton(
			action: action,
			label: { Image(systemName: "arrow.clockwise") }
		)
	}
}

#Preview {
	RefreshButton(
		action: {
			print("Refreshing")
		}
	)
}
