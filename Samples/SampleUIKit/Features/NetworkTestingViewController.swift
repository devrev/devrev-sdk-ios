import Foundation
import UIKit

/// A view controller that exercises various network request patterns for observability testing.
final class NetworkTestingViewController: UITableViewController {
	// MARK: - Types

	/// The result of a completed network request displayed in the results section.
	private struct RequestResult {
		let method: String
		let url: String
		let statusCode: Int?
		let duration: Int
		let responseSize: Int?
		let error: String?
	}

	/// A table view section with a title and tappable rows.
	private struct Section {
		let title: String
		let rows: [(title: String, action: () -> Void)]
	}

	// MARK: - Properties

	private var results: [RequestResult] = []
	private let cellID = "NetworkTestCell"
	private let resultCellID = "ResultCell"

	private lazy var sections: [Section] = [
		Section(title: "Real APIs", rows: [
			("JSONPlaceholder — Users (emails, phones, geo)", { [weak self] in
				self?.fire("GET", "https://jsonplaceholder.typicode.com/users")
			}),
			("ipinfo.io — IP + location", { [weak self] in
				self?.fire("GET", "https://ipinfo.io/json")
			}),
			("GitHub — User + Bearer token", { [weak self] in
				self?.fire("GET", "https://api.github.com/users/octocat", headers: [
					"Authorization": "Bearer ghp_fakeToken1234567890abcdef",
				])
			}),
			("JSONPlaceholder — POST with PII body", { [weak self] in
				self?.fire("POST", "https://jsonplaceholder.typicode.com/comments", body: [
					"name": "John Doe",
					"email": "john.doe@example.com",
					"body": "Call +1(555)867-5309 or visit 192.168.1.42",
				])
			}),
			("iTunes — Search (query params)", { [weak self] in
				self?.fire("GET", "https://itunes.apple.com/search?term=devrev&entity=software&limit=3")
			}),
		]),
		Section(title: "PII Scrubbing — URL", rows: [
			("Path — email, UUID, numeric ID, IPv4", { [weak self] in
				let url = "https://httpbin.org/anything/users/john@example.com"
					+ "/orders/550e8400-e29b-41d4-a716-446655440000"
					+ "/items/1234567890/servers/192.168.1.42"
				self?.fire("GET", url)
			}),
			("Path — JWT, phone, API key", { [weak self] in
				let jwt = "eyJhbGciOiJIUzI1NiJ9"
					+ ".eyJzdWIiOiIxMjM0NTY3ODkwIn0"
					+ ".dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U"
				let url = "https://httpbin.org/anything/token/\(jwt)"
					+ "/verify/+15558675309/key/sk_live_abc123def456ghi789jkl"
				self?.fire("GET", url)
			}),
			("Query — apiKey, token, userId", { [weak self] in
				let url = "https://httpbin.org/anything/search"
					+ "?apiKey=sk_live_abc123&token=secret&userId=9876543210&page=1"
				self?.fire("GET", url)
			}),
		]),
		Section(title: "PII Scrubbing — Headers & Body", rows: [
			("Headers — auth, cookie, tokens, PII values", { [weak self] in
				self?.fire("GET", "https://httpbin.org/anything/protected", headers: [
					"Authorization": "Bearer sk_live_supersecret",
					"Cookie": "session=abc123",
					"X-Access-Token": "tok_abc123",
					"X-User-Email": "john@example.com",
				])
			}),
			("JSON body — sensitive keys", { [weak self] in
				self?.fire("POST", "https://httpbin.org/anything/submit", body: [
					"email": "john.doe@example.com",
					"ssn": "123-45-6789",
					"card_number": "4111111111111111",
					"phone": "+1(555)867-5309",
					"password": "s3cret!",
				])
			}),
			("JSON body — inline PII in text values", { [weak self] in
				self?.fire("POST", "https://httpbin.org/anything/report", body: [
					"summary": "User at 192.168.1.42 (MAC 00:1A:2B:3C:4D:5E)",
					"detail": "Contact john@example.com or +1(555)867-5309",
					"log": "IPv6 2001:0db8:85a3:0000:0000:8a2e:0370:7334 connected",
				])
			}),
			("Form-encoded body", { [weak self] in
				self?.fireFormEncoded("https://httpbin.org/post", fields: [
					"username": "john.doe",
					"password": "s3cret!",
					"email": "john@example.com",
				])
			}),
			("Multipart form POST (PII fields)", { [weak self] in
				self?.fireMultipart("https://httpbin.org/post", fields: [
					"email": "john.doe@example.com",
					"password": "s3cret!",
					"phone": "+1(555)867-5309",
				])
			}),
			("Combo — PII path + headers + body", { [weak self] in
				self?.fire(
					"POST",
					"https://httpbin.org/anything/users/jane@corp.co/update",
					body: ["accountId": "9876543210"],
					headers: ["Authorization": "Bearer sk_live_supersecret"]
				)
			}),
		]),
		Section(title: "Response Formats", rows: [
			("JSON — httpbin/get", { [weak self] in
				self?.fire("GET", "https://httpbin.org/get")
			}),
			("Image (PNG)", { [weak self] in
				self?.fire("GET", "https://httpbin.org/image/png")
			}),
			("Gzip compressed", { [weak self] in
				self?.fire("GET", "https://httpbin.org/gzip")
			}),
			("Deflate compressed", { [weak self] in
				self?.fire("GET", "https://httpbin.org/deflate")
			}),
			("Binary (octet-stream)", { [weak self] in
				self?.fire("GET", "https://httpbin.org/bytes/2048")
			}),
			("XML", { [weak self] in
				self?.fire("GET", "https://httpbin.org/xml")
			}),
			("HTML", { [weak self] in
				self?.fire("GET", "https://httpbin.org/html")
			}),
			("Large JSON (5000 items)", { [weak self] in
				self?.fire("GET", "https://jsonplaceholder.typicode.com/photos")
			}),
		]),
		Section(title: "Tasks & Errors", rows: [
			("Async/await GET", { [weak self] in
				Task { await self?.fireAsync("https://httpbin.org/get") }
			}),
			("Download task", { [weak self] in
				self?.fireDownload("https://httpbin.org/bytes/4096")
			}),
			("Upload task", { [weak self] in
				self?.fireUpload("https://httpbin.org/post")
			}),
			("Redirect chain (3 hops)", { [weak self] in
				self?.fire("GET", "https://httpbin.org/redirect/3")
			}),
			("Custom session (ephemeral)", { [weak self] in
				self?.fireCustomSession("https://httpbin.org/get")
			}),
			("HTTP 404", { [weak self] in
				self?.fire("GET", "https://httpbin.org/status/404")
			}),
			("Timeout (5s)", { [weak self] in
				self?.fire("GET", "https://httpbin.org/delay/10", timeout: 5)
			}),
			("DNS failure", { [weak self] in
				self?.fire("GET", "https://invalid-host-12345.invalid/test")
			}),
			("Concurrent burst (5)", { [weak self] in
				self?.fireConcurrentBurst()
			}),
		]),
	]

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Network Testing"
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCellID)
	}

	// MARK: - UITableViewDataSource

	override func numberOfSections(in tableView: UITableView) -> Int {
		sections.count + 1
	}

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		if section < sections.count {
			return sections[section].rows.count
		}
		return results.count
	}

	override func tableView(
		_ tableView: UITableView,
		titleForHeaderInSection section: Int
	) -> String? {
		if section < sections.count {
			return sections[section].title
		}
		return results.isEmpty ? nil : "Results (\(results.count))"
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		if indexPath.section < sections.count {
			let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
			cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
			cell.textLabel?.textColor = .systemBlue
			return cell
		}

		let cell = tableView.dequeueReusableCell(withIdentifier: resultCellID, for: indexPath)
		let result = results[indexPath.row]
		cell.selectionStyle = .none

		var config = cell.defaultContentConfiguration()
		let status = result.statusCode.map { "\($0)" } ?? "ERR"
		config.text = "\(result.method)  \(status)  \(result.duration)ms"
		config.secondaryText = result.error ?? result.url
		config.textProperties.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
		config.secondaryTextProperties.font = .systemFont(ofSize: 12)
		config.secondaryTextProperties.color = result.error != nil ? .systemRed : .secondaryLabel
		config.secondaryTextProperties.numberOfLines = 2
		cell.contentConfiguration = config
		return cell
	}

	// MARK: - UITableViewDelegate

	override func tableView(
		_ tableView: UITableView,
		didSelectRowAt indexPath: IndexPath
	) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard indexPath.section < sections.count
		else {
			return
		}
		sections[indexPath.section].rows[indexPath.row].action()
	}
}

// MARK: - Networking

private extension NetworkTestingViewController {
	func recordResult(
		method: String,
		url: String,
		start: CFAbsoluteTime,
		response: URLResponse?,
		size: Int?,
		error: Error?
	) {
		let result = RequestResult(
			method: method,
			url: url,
			statusCode: (response as? HTTPURLResponse)?.statusCode,
			duration: Int((CFAbsoluteTimeGetCurrent() - start) * 1000),
			responseSize: size,
			error: error?.localizedDescription
		)
		DispatchQueue.main.async { [weak self] in
			self?.results.insert(result, at: 0)
			self?.tableView.reloadData()
		}
	}

	func fire(
		_ method: String,
		_ urlString: String,
		body: [String: String]? = nil,
		headers: [String: String]? = nil,
		timeout: TimeInterval = 30
	) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		var request = URLRequest(url: url, timeoutInterval: timeout)
		request.httpMethod = method
		headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

		if let body {
			request.httpBody = try? JSONSerialization.data(withJSONObject: body)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		let start = CFAbsoluteTimeGetCurrent()
		let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.recordResult(
				method: method,
				url: urlString,
				start: start,
				response: response,
				size: data?.count,
				error: error
			)
		}
		task.resume()
	}

	func fireFormEncoded(_ urlString: String, fields: [String: String]) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = fields.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)

		let start = CFAbsoluteTimeGetCurrent()
		let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.recordResult(
				method: "POST",
				url: urlString,
				start: start,
				response: response,
				size: data?.count,
				error: error
			)
		}
		task.resume()
	}

	func fireMultipart(_ urlString: String, fields: [String: String]) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		let boundary = "Boundary-\(UUID().uuidString)"
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

		var body = Data()
		for (key, value) in fields {
			body.append(Data("--\(boundary)\r\n".utf8))
			body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
			body.append(Data("\(value)\r\n".utf8))
		}
		body.append(Data("--\(boundary)--\r\n".utf8))
		request.httpBody = body

		let start = CFAbsoluteTimeGetCurrent()
		let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
			self?.recordResult(
				method: "POST",
				url: urlString,
				start: start,
				response: response,
				size: data?.count,
				error: error
			)
		}
		task.resume()
	}

	func fireAsync(_ urlString: String) async {
		guard let url = URL(string: urlString)
		else {
			return
		}

		let start = CFAbsoluteTimeGetCurrent()
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			recordResult(
				method: "GET",
				url: urlString,
				start: start,
				response: response,
				size: data.count,
				error: nil
			)
		}
		catch {
			recordResult(
				method: "GET",
				url: urlString,
				start: start,
				response: nil,
				size: nil,
				error: error
			)
		}
	}

	func fireDownload(_ urlString: String) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		let start = CFAbsoluteTimeGetCurrent()
		let task = URLSession.shared.downloadTask(with: url) { [weak self] fileURL, response, error in
			let size = fileURL.flatMap {
				try? FileManager.default.attributesOfItem(atPath: $0.path)[.size] as? Int
			}
			self?.recordResult(
				method: "DOWNLOAD",
				url: urlString,
				start: start,
				response: response,
				size: size,
				error: error
			)
		}
		task.resume()
	}

	func fireUpload(_ urlString: String) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

		let start = CFAbsoluteTimeGetCurrent()
		let task = URLSession.shared.uploadTask(
			with: request,
			from: Data(repeating: 0xAB, count: 1024)
		) { [weak self] data, response, error in
			self?.recordResult(
				method: "UPLOAD",
				url: urlString,
				start: start,
				response: response,
				size: data?.count,
				error: error
			)
		}
		task.resume()
	}

	func fireCustomSession(_ urlString: String) {
		guard let url = URL(string: urlString)
		else {
			return
		}

		let config = URLSessionConfiguration.ephemeral
		config.timeoutIntervalForRequest = 30

		let start = CFAbsoluteTimeGetCurrent()
		let session = URLSession(configuration: config)
		let task = session.dataTask(with: url) { [weak self] data, response, error in
			self?.recordResult(
				method: "GET",
				url: "[ephemeral] \(urlString)",
				start: start,
				response: response,
				size: data?.count,
				error: error
			)
		}
		task.resume()
	}

	func fireConcurrentBurst() {
		let urls = [
			"https://httpbin.org/get",
			"https://httpbin.org/status/201",
			"https://httpbin.org/delay/1",
			"https://httpbin.org/bytes/1024",
			"https://httpbin.org/status/404",
		]
		for url in urls {
			fire("GET", url)
		}
	}
}
