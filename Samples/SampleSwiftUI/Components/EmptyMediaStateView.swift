import SwiftUI

struct EmptyStateView: View {
	let systemImageName: String
	let title: String
	let message: String

	var body: some View {
		VStack(spacing: 24) {
			Spacer()

			Image(systemName: systemImageName)
				.font(.system(size: 80))
				.foregroundColor(.gray.opacity(0.3))
				.padding(.bottom, 8)

			Text(title)
				.font(.title3.weight(.medium))
				.foregroundColor(.gray)

			Text(message)
				.font(.subheadline)
				.foregroundColor(.gray.opacity(0.8))
				.multilineTextAlignment(.center)
				.padding(.horizontal, 40)

			Spacer()
		}
	}
}
