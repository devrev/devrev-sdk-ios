import Foundation
import SwiftUI

struct AsyncButton<Label: View>: View {
	var role: ButtonRole?
	var action: () async -> Void
	var actionOptions = Set(ActionOption.allCases)
	@ViewBuilder var label: () -> Label

	@State private var isDisabled = false
	@State private var showProgressView = false

	var body: some View {
		Button(
			role: role,
			action: {
				if actionOptions.contains(.disableButton) {
					isDisabled = true
				}

				Task {
					var progressViewTask: Task<Void, Error>?

					if actionOptions.contains(.showProgressView) {
						progressViewTask = Task {
							try await Task.sleep(nanoseconds: 150_000_000)
							showProgressView = true
						}
					}

					await action()
					progressViewTask?.cancel()

					isDisabled = false
					showProgressView = false
				}
			},
			label: {
				ZStack {
					label().opacity(showProgressView ? 0 : 1)

					if showProgressView {
						ProgressView()
					}
				}
			}
		)
		.disabled(
			isDisabled
		)
	}
}

extension AsyncButton {
	enum ActionOption: CaseIterable {
		case disableButton
		case showProgressView
	}
}

extension AsyncButton where Label == Text {
	init(
		text: String,
		role: ButtonRole? = nil,
		actionOptions: Set<ActionOption> = .init(ActionOption.allCases),
		action: @escaping () async -> Void
	) {
		self.init(
			role: role,
			action: action,
			actionOptions: actionOptions,
			label: {
				Text(text)
			}
		)
	}
}

extension AsyncButton where Label == Image {
	init(
		systemImageName: String,
		actionOptions: Set<ActionOption> = .init(ActionOption.allCases),
		action: @escaping () async -> Void
	) {
		self.init(
			role: nil,
			action: action,
			actionOptions: actionOptions,
			label: {
				Image(systemName: systemImageName)
			}
		)
	}
}
