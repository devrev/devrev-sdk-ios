import Foundation
import SwiftUI
import WebKit

struct WebViewWrapper: UIViewRepresentable {
	let url: URL?

	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		if #available(iOS 16.4, *) {
			webView.isInspectable = true
		}
		return webView
	}

	func updateUIView(_ uiView: WKWebView, context: Context) {
		guard
			let url
		else {
			let html = "<h2 style='color:red'>Could not load the HTML!</h2>"
			uiView.loadHTMLString(html, baseURL: nil)
			return
		}

		let request = URLRequest(url: url)
		uiView.load(request)
	}
}
