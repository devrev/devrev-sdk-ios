import Foundation
import UIKit
import WebKit
import DevRevSDK

class MaskedWebViewViewController: UIViewController {
	private let webView = WKWebView(frame: .zero)

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Masking Web View", comment: "")

		webView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(webView)

		NSLayoutConstraint.activate([
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])

		loadHTML()
	}

	private func loadHTML() {
		guard
			let url = Bundle.main.url(forResource: "web-view-masking", withExtension: "html")
		else {
			let html = "<h2 style='color:red'>Could not load the HTML!</h2>"
			webView.loadHTMLString(html, baseURL: nil)
			return
		}

		let request = URLRequest(url: url)
		webView.load(request)
	}
}
