import Foundation
import SwiftUI

/// A view that exercises various network request patterns for observability testing.
struct NetworkTestingView: View {
	@State private var results: [RequestResult] = []
	@State private var customURL = "https://httpbin.org/get"
	@State private var isLoading = false
	@State private var toast: ToastInfo?
	@State private var sseConnected = false
	@State private var sseEventCount = 0
	@State private var sseLastEvent: String?
	@State private var sseSession: URLSession?
	@State private var sseTask: URLSessionDataTask?
	@State private var sseDelegate: SSEConnectionDelegate?

	var body: some View {
		ZStack(alignment: .top) {
			List {
				realWorldSection
				piiSection
				responseFormatsSection
				tasksSection
				sseSection
				customRequestSection
				resultsSection
			}

			if let toast {
				toastView(toast)
					.transition(.move(edge: .top).combined(with: .opacity))
					.zIndex(1)
			}
		}
		.animation(.spring(response: 0.35, dampingFraction: 0.8), value: toast)
		.navigationTitle("Network Testing")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				AsyncImage(url: URL(string: "https://httpbin.org/image/png")) { image in
					image.resizable().scaledToFit()
				} placeholder: {
					ProgressView()
				}
				.frame(width: 28, height: 28)
				.clipShape(RoundedRectangle(cornerRadius: 6))
			}
		}
	}

	// MARK: - Sections

	private var realWorldSection: some View {
		Section("Real APIs") {
			Button("JSONPlaceholder — Users (emails, phones, geo)") {
				fire(.get, "https://jsonplaceholder.typicode.com/users")
			}
			Button("ipinfo.io — IP + location") {
				fire(.get, "https://ipinfo.io/json")
			}
			Button("GitHub — User + Bearer token") {
				fire(.get, "https://api.github.com/users/octocat", headers: [
					"Authorization": "Bearer ghp_fakeToken1234567890abcdef",
				])
			}
			Button("JSONPlaceholder — POST with PII body") {
				fire(.post, "https://jsonplaceholder.typicode.com/comments", body: [
					"name": "John Doe",
					"email": "john.doe@example.com",
					"body": "Call +1(555)867-5309 or visit 192.168.1.42",
				])
			}
			Button("iTunes — Search (query params)") {
				fire(.get, "https://itunes.apple.com/search?term=devrev&entity=software&limit=3")
			}
		}
	}

	@ViewBuilder
	private var piiSection: some View {
		Section("PII Scrubbing — URL") {
			Button("Path — email, UUID, numeric ID, IPv4") {
				let url = "https://httpbin.org/anything/users/john@example.com"
					+ "/orders/550e8400-e29b-41d4-a716-446655440000"
					+ "/items/1234567890/servers/192.168.1.42"
				fire(.get, url)
			}
			Button("Path — JWT, phone, API key") {
				let jwt = "eyJhbGciOiJIUzI1NiJ9"
					+ ".eyJzdWIiOiIxMjM0NTY3ODkwIn0"
					+ ".dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U"
				let url = "https://httpbin.org/anything/token/\(jwt)"
					+ "/verify/+15558675309/key/sk_live_abc123def456ghi789jkl"
				fire(.get, url)
			}
			Button("Query — apiKey, token, userId") {
				let url = "https://httpbin.org/anything/search"
					+ "?apiKey=sk_live_abc123&token=secret&userId=9876543210&page=1"
				fire(.get, url)
			}
		}

		Section("PII Scrubbing — Headers & Body") {
			Button("Headers — auth, cookie, tokens, PII values") {
				fire(.get, "https://httpbin.org/anything/protected", headers: [
					"Authorization": "Bearer sk_live_supersecret",
					"Cookie": "session=abc123",
					"X-Access-Token": "tok_abc123",
					"X-User-Email": "john@example.com",
				])
			}
			Button("JSON body — sensitive keys") {
				fire(.post, "https://httpbin.org/anything/submit", body: [
					"email": "john.doe@example.com",
					"ssn": "123-45-6789",
					"card_number": "4111111111111111",
					"phone": "+1(555)867-5309",
					"password": "s3cret!",
				])
			}
			Button("JSON body — inline PII in text values") {
				fire(.post, "https://httpbin.org/anything/report", body: [
					"summary": "User at 192.168.1.42 (MAC 00:1A:2B:3C:4D:5E)",
					"detail": "Contact john@example.com or +1(555)867-5309",
					"log": "IPv6 2001:0db8:85a3:0000:0000:8a2e:0370:7334 connected",
				])
			}
			Button("Form-encoded body") {
				fireFormEncoded("https://httpbin.org/post", fields: [
					"username": "john.doe",
					"password": "s3cret!",
					"email": "john@example.com",
				])
			}
			Button("Multipart form POST (PII fields)") {
				fireMultipart("https://httpbin.org/post", fields: [
					"email": "john.doe@example.com",
					"password": "s3cret!",
					"phone": "+1(555)867-5309",
				])
			}
			Button("Combo — PII path + headers + body") {
				fire(
					.post,
					"https://httpbin.org/anything/users/jane@corp.co/update",
					body: [
						"accountId": "9876543210",
						"token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.sig",
					],
					headers: [
						"Authorization": "Bearer sk_live_supersecret",
						"X-Forwarded-For": "10.0.0.1",
					]
				)
			}
		}
	}

	private var responseFormatsSection: some View {
		Section("Response Formats") {
			Button("JSON — httpbin/get") {
				fire(.get, "https://httpbin.org/get")
			}
			Button("Image (PNG)") {
				fire(.get, "https://httpbin.org/image/png")
			}
			Button("Gzip compressed") {
				fire(.get, "https://httpbin.org/gzip")
			}
			Button("Deflate compressed") {
				fire(.get, "https://httpbin.org/deflate")
			}
			Button("Binary (octet-stream)") {
				fire(.get, "https://httpbin.org/bytes/2048")
			}
			Button("XML") {
				fire(.get, "https://httpbin.org/xml")
			}
			Button("HTML") {
				fire(.get, "https://httpbin.org/html")
			}
			Button("Large JSON (5000 items)") {
				fire(.get, "https://jsonplaceholder.typicode.com/photos")
			}
		}
	}

	private var tasksSection: some View {
		Section("Tasks & Errors") {
			Button("Async/await GET") {
				Task { await fireAsync("https://httpbin.org/get") }
			}
			Button("Download task") {
				fireDownload("https://httpbin.org/bytes/4096")
			}
			Button("Upload task") {
				fireUpload("https://httpbin.org/post")
			}
			Button("Redirect chain (3 hops)") {
				fire(.get, "https://httpbin.org/redirect/3")
			}
			Button("Custom session (ephemeral)") {
				fireCustomSession("https://httpbin.org/get")
			}
			Button("HTTP 404") {
				fire(.get, "https://httpbin.org/status/404")
			}
			Button("Timeout (5s)") {
				fire(.get, "https://httpbin.org/delay/10", timeout: 5)
			}
			Button("DNS failure") {
				fire(.get, "https://invalid-host-12345.invalid/test")
			}
			Button("Concurrent burst (5)") {
				fireConcurrentBurst()
			}
		}
	}

	private var sseSection: some View {
		Section("SSE (Server-Sent Events)") {
			if !sseConnected {
				Button("Connect to Wikipedia Live Stream") {
					startSSE()
				}
			}
			else {
				HStack {
					Circle().fill(.green).frame(width: 8, height: 8)
					Text("Connected — \(sseEventCount) events")
						.font(.caption.monospacedDigit())
					Spacer()
					Button("Disconnect") { stopSSE() }
						.foregroundColor(.red).font(.caption.bold())
				}
				if let sseLastEvent {
					Text(sseLastEvent)
						.font(.caption2).foregroundColor(.secondary).lineLimit(3)
				}
			}
		}
	}

	private var customRequestSection: some View {
		Section("Custom Request") {
			TextField("URL", text: $customURL)
				.textContentType(.URL)
				.textInputAutocapitalization(.never)
				.autocorrectionDisabled()
			Button("Send GET") { fire(.get, customURL) }
		}
	}

	// MARK: - Results

	private var resultsSection: some View {
		Section(header: HStack {
			Text("Results (\(results.count))")
			Spacer()
			if !results.isEmpty {
				Button("Clear") { results.removeAll() }.font(.caption)
			}
		}) {
			if isLoading {
				HStack { ProgressView(); Text("Loading...").foregroundColor(.secondary) }
			}
			ForEach(results) { result in
				resultRow(result)
			}
		}
	}

	private func resultRow(_ result: RequestResult) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			HStack {
				Text(result.method)
					.font(.caption.bold())
					.padding(.horizontal, 6)
					.padding(.vertical, 2)
					.background(methodColor(result.method).opacity(0.2))
					.cornerRadius(4)
				Text(result.statusCode.map { "\($0)" } ?? "ERR")
					.font(.caption.bold())
					.foregroundColor(statusColor(result))
				Spacer()
				Text("\(result.duration)ms")
					.font(.caption.monospacedDigit())
					.foregroundColor(result.duration > 2000 ? .red : .secondary)
			}
			Text(result.url).font(.caption2).foregroundColor(.secondary).lineLimit(2)
			if let size = result.responseSize {
				Text("Response: \(ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .memory))")
					.font(.caption2).foregroundColor(.secondary)
			}
			if let error = result.error {
				Text(error).font(.caption2).foregroundColor(.red)
			}
		}
		.padding(.vertical, 2)
	}
}

// MARK: - Networking

private extension NetworkTestingView {
	func fire(
		_ method: HTTPMethod,
		_ urlString: String,
		body: [String: String]? = nil,
		headers: [String: String]? = nil,
		timeout: TimeInterval = 30
	) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true

		var request = URLRequest(url: url, timeoutInterval: timeout)
		request.httpMethod = method.rawValue
		headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }

		if let body {
			request.httpBody = try? JSONSerialization.data(withJSONObject: body)
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		let start = CFAbsoluteTimeGetCurrent()

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: method.rawValue,
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data?.count,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
		}
		task.resume()
	}

	func fireFormEncoded(_ urlString: String, fields: [String: String]) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

		let body = fields.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
		request.httpBody = body.data(using: .utf8)

		let start = CFAbsoluteTimeGetCurrent()

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "POST",
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data?.count,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
		}
		task.resume()
	}

	func fireMultipart(_ urlString: String, fields: [String: String]) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true
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

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "POST",
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data?.count,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
		}
		task.resume()
	}

	func fireAsync(_ urlString: String) async {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true
		let start = CFAbsoluteTimeGetCurrent()

		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "GET",
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data.count,
				error: nil
			)
			results.insert(result, at: 0)
			isLoading = false
			showToast(for: result)
		}
		catch {
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "GET",
				url: urlString,
				statusCode: nil,
				duration: duration,
				responseSize: nil,
				error: error.localizedDescription
			)
			results.insert(result, at: 0)
			isLoading = false
			showToast(for: result)
		}
	}

	func fireDownload(_ urlString: String) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true
		let start = CFAbsoluteTimeGetCurrent()

		let task = URLSession.shared.downloadTask(with: url) { fileURL, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			var size: Int?
			if let fileURL {
				size = (try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int)
			}
			let result = RequestResult(
				method: "DOWNLOAD",
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: size,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
		}
		task.resume()
	}

	func fireUpload(_ urlString: String) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true
		let start = CFAbsoluteTimeGetCurrent()

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

		let task = URLSession.shared.uploadTask(
			with: request,
			from: Data(repeating: 0xAB, count: 1024)
		) { data, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "UPLOAD",
				url: urlString,
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data?.count,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
		}
		task.resume()
	}

	func fireCustomSession(_ urlString: String) {
		guard
			let url = URL(string: urlString)
		else {
			return
		}

		isLoading = true
		let start = CFAbsoluteTimeGetCurrent()

		let config = URLSessionConfiguration.ephemeral
		config.timeoutIntervalForRequest = 30
		let session = URLSession(configuration: config)

		let task = session.dataTask(with: url) { data, response, error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "GET",
				url: "[ephemeral] \(urlString)",
				statusCode: (response as? HTTPURLResponse)?.statusCode,
				duration: duration,
				responseSize: data?.count,
				error: error?.localizedDescription
			)
			DispatchQueue.main.async {
				results.insert(result, at: 0)
				isLoading = false
				showToast(for: result)
			}
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
			fire(.get, url)
		}
	}

	// MARK: - SSE

	func startSSE() {
		guard
			let url = URL(string: "https://stream.wikimedia.org/v2/stream/recentchange")
		else {
			return
		}

		let start = CFAbsoluteTimeGetCurrent()
		let delegate = SSEConnectionDelegate()

		delegate.onEvent = { eventText in
			sseEventCount += 1
			sseLastEvent = eventText
		}
		delegate.onComplete = { error in
			let duration = Int((CFAbsoluteTimeGetCurrent() - start) * 1000)
			let result = RequestResult(
				method: "SSE",
				url: url.absoluteString,
				statusCode: error == nil ? 200 : nil,
				duration: duration,
				responseSize: nil,
				error: error?.localizedDescription
			)
			results.insert(result, at: 0)
			showToast(for: result)
			sseConnected = false
			sseEventCount = 0
			sseLastEvent = nil
			sseSession = nil
			sseTask = nil
			sseDelegate = nil
		}

		self.sseDelegate = delegate
		var request = URLRequest(url: url)
		request.setValue("text/event-stream", forHTTPHeaderField: "Accept")

		let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
		let task = session.dataTask(with: request)
		sseSession = session
		sseTask = task
		sseConnected = true
		task.resume()
	}

	func stopSSE() {
		sseTask?.cancel()
		sseSession?.invalidateAndCancel()
	}
}

// MARK: - Toast

private extension NetworkTestingView {
	func toastView(_ info: ToastInfo) -> some View {
		HStack(spacing: 8) {
			Circle().fill(info.color).frame(width: 8, height: 8)
			Text(info.method).font(.caption2.bold())
			Text(info.message).font(.caption2).lineLimit(1)
			Spacer()
			Text("\(info.duration)ms").font(.caption2.monospacedDigit().bold())
		}
		.padding(.horizontal, 14)
		.padding(.vertical, 10)
		.background(.ultraThinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.shadow(color: .black.opacity(0.12), radius: 8, y: 4)
		.padding(.horizontal, 16)
		.padding(.top, 4)
	}

	func showToast(for result: RequestResult) {
		let message: String
		if let code = result.statusCode {
			let size = result.responseSize.map {
				" · \(ByteCountFormatter.string(fromByteCount: Int64($0), countStyle: .memory))"
			} ?? ""
			message = "\(code)\(size)"
		}
		else {
			message = result.error ?? "Failed"
		}

		let color: Color
		if let code = result.statusCode, (200..<300).contains(code) {
			color = .green
		}
		else if result.error != nil {
			color = .red
		}
		else {
			color = .orange
		}

		withAnimation {
			toast = ToastInfo(method: result.method, message: message, duration: result.duration, color: color)
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
			withAnimation {
				if self.toast?.id == toast?.id { self.toast = nil }
			}
		}
	}

	func methodColor(_ method: String) -> Color {
		switch method {
		case "GET": return .blue
		case "POST": return .green
		case "PUT": return .orange
		case "DELETE": return .red
		case "SSE": return .purple
		default: return .gray
		}
	}

	func statusColor(_ result: RequestResult) -> Color {
		guard
			let code = result.statusCode
		else {
			return .red
		}
		switch code {
		case 200..<300: return .green
		case 300..<400: return .orange
		default: return .red
		}
	}
}

// MARK: - SSE Delegate

/// Handles SSE (Server-Sent Events) streaming by buffering incoming data and parsing events.
private final class SSEConnectionDelegate: NSObject, URLSessionDataDelegate {
	// MARK: - Properties

	var onEvent: ((String) -> Void)?
	var onComplete: ((Error?) -> Void)?
	private var buffer = Data()

	// MARK: - URLSessionDataDelegate

	func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
		buffer.append(data)

		guard
			let text = String(data: buffer, encoding: .utf8)
		else {
			return
		}

		let chunks = text.components(separatedBy: "\n\n")

		guard
			chunks.count > 1
		else {
			return
		}

		for index in 0..<(chunks.count - 1) {
			let dataLines = chunks[index]
				.components(separatedBy: "\n")
				.filter { $0.hasPrefix("data:") }
				.map { String($0.dropFirst(5)).trimmingCharacters(in: .whitespaces) }

			guard
				!dataLines.isEmpty
			else {
				continue
			}

			let payload = dataLines.joined(separator: "\n")
			if let jsonData = payload.data(using: .utf8),
			   let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
				let title = json["title"] as? String ?? "?"
				let user = json["user"] as? String ?? "?"
				let wiki = json["wiki"] as? String ?? "?"
				DispatchQueue.main.async { self.onEvent?("[\(wiki)] \(user) edited \"\(title)\"") }
			}
			else {
				let preview = String(payload.prefix(120))
				DispatchQueue.main.async { self.onEvent?(preview) }
			}
		}

		if let lastChunk = chunks.last, let remaining = lastChunk.data(using: .utf8) {
			buffer = remaining
		}
		else {
			buffer = Data()
		}
	}

	func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
		DispatchQueue.main.async { self.onComplete?(error) }
	}
}

// MARK: - Types

extension NetworkTestingView {
	/// HTTP methods supported by the network testing view.
	enum HTTPMethod: String {
		case get = "GET"
		case post = "POST"
		case put = "PUT"
		case delete = "DELETE"
	}

	/// The result of a completed network request displayed in the results list.
	struct RequestResult: Identifiable {
		let id = UUID()
		let method: String
		let url: String
		let statusCode: Int?
		let duration: Int
		let responseSize: Int?
		let error: String?
	}

	/// Toast notification state shown briefly after a request completes.
	struct ToastInfo: Equatable {
		let id = UUID()
		let method: String
		let message: String
		let duration: Int
		let color: Color

		static func == (lhs: ToastInfo, rhs: ToastInfo) -> Bool { lhs.id == rhs.id }
	}
}
