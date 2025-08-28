import Foundation
import SwiftUI
import DevRevSDK

struct ListViewScreen: View {
	private let title = "List View"
	private let items = (0..<100).map {
		"Item #\($0)"
	}

	var body: some View {
		List(Array(items.enumerated()), id: \.offset) { index, item in
			if index.isMultiple(of: 2) {
				MaskedLabelView(text: item)
					.padding()
			}
			else {
				Text(item)
					.padding()
			}
		}
		.navigationTitle(title)
	}
}
