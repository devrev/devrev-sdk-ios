import Foundation
import SwiftUI

struct StatusRow: View {
	@State var status: String
	@Binding var isComplete: Bool

	var body: some View {
		HStack {
			Text(status)
			Spacer()
			Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
				.symbolRenderingMode(.multicolor)
				.foregroundStyle(Color.accentColor)
		}
	}
}

#Preview {
	StatusRow(
		status: "Is Cartman big-boned?",
		isComplete: .constant(true)
	)
	StatusRow(
		status: "Is the Earth flat?",
		isComplete: .constant(false)
	)
}
