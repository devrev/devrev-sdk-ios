import Foundation
import SwiftUI
import DevRevSDK

struct MaskedWebView: View {
	private let url = Bundle.main.url(
		forResource: "web-view-masking",
		withExtension: "html"
	)

	var body: some View {
		WebViewWrapper(url: url)
			.accessibilityIdentifier(TestConstants.AccessibilityID.MaskedWebView.webView)
			.navigationTitle("Web View Masking")
			.navigationBarTitleDisplayMode(.inline)
	}
}
