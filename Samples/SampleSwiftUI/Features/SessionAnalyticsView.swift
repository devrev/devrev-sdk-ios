import Foundation
import SwiftUI
import DevRevSDK

struct SessionAnalyticsView: View {
	private let title = "Session Analytics"

	@SwiftUI.State private var isMonitoringEnabled = false
	@SwiftUI.State private var isRecording = false
	@SwiftUI.State private var isWebViewPresented = false

	var body: some View {
		List {
			statusSection
			sessionMonitoringSection
			featureConfigurationSection
			sessionRecordingSection
			mediaSection
			timerSection
			errorCaptureSection
			manualMaskingSection
			onDemandSessionsSection
			webViewSection
			largeScrollableListSection
		}
		.navigationTitle(title)
		.navigationBarItems(trailing: RefreshButton(action: updateStatuses))
		.refreshable {
			await updateStatuses()
		}
		.task {
			await updateStatuses()
		}
	}

	private var statusSection: some View {
		Section(header: Text("Status")) {
			StatusRow(
				status: "Is session monitoring enabled?",
				isComplete: $isMonitoringEnabled
			)
			StatusRow(
				status: "Is the session recorded?",
				isComplete: $isRecording
			)
		}
	}

	private var sessionMonitoringSection: some View {
		Section(header: Text("Session Monitoring")) {
			AsyncButton(text: "Stop Monitoring") {
				DevRev.stopAllMonitoring()
				await updateStatuses()
			}
			AsyncButton(text: "Resume All Monitoring") {
				DevRev.resumeAllMonitoring()
				await updateStatuses()
			}
		}
	}

	private var featureConfigurationSection: some View {
		Section(header: Text("Feature Configuration")) {
			AsyncButton(text: "Disable Frame Capture") {
				DevRev.updateFeatureConfiguration(
					.init(withShouldEnableFrameCapture: false)
				)
			}
			AsyncButton(text: "Update Support Widget Theme") {
				let theme = SupportWidgetTheme(
					prefersSystemTheme: false,
					primaryTextColor: "#1F2933",
					accentColor: "#F97316",
					spacing: ["bottom": "20px", "side": "16px"]
				)

				DevRev.updateFeatureConfiguration(
					.init(witCustomSupportWidgetTheme: theme)
				)
			}
		}
	}

	private var sessionRecordingSection: some View {
		Section(header: Text("Session Recording")) {
			AsyncButton(text: "Start Recording") {
				await DevRev.startRecording()
				await updateStatuses()
			}
			AsyncButton(text: "Stop Recording") {
				DevRev.stopRecording()
				await updateStatuses()
			}
			AsyncButton(text: "Pause Recording") {
				DevRev.pauseRecording()
				await updateStatuses()
			}
			AsyncButton(text: "Resume Recording") {
				DevRev.resumeRecording()
				await updateStatuses()
			}
		}
	}

	private var mediaSection: some View {
		Section(header: Text("Media")) {
			NavigationLink(destination: CameraView()) {
				Text("Camera")
			}
			NavigationLink(destination: GalleryView()) {
				Text("Gallery")
			}
		}
	}

	private var timerSection: some View {
		Section(header: Text("Timer")) {
			AsyncButton(text: "Start Timer") {
				let property: [String: String] = ["test-key1": "test-value1"]
				DevRev.startTimer("test-event", properties: property)
				await updateStatuses()
			}
			AsyncButton(text: "Stop Timer") {
				let property: [String: String] = ["test-key2": "test-value2"]
				DevRev.endTimer("test-event", properties: property)
				await updateStatuses()
			}
		}
	}

	private var errorCaptureSection: some View {
		Section(header: Text("Error Capture")) {
			HStack {
				AsyncButton(text: "Capture Error") {
					captureTestError()
					await updateStatuses()
				}
				.foregroundColor(.yellow)
				Spacer()
				Image(systemName: "exclamationmark.circle")
					.foregroundColor(.yellow)
			}
		}
	}

	private var manualMaskingSection: some View {
		Section(header: Text("Manual Masking / Unmasking")) {
			MaskedLabelView(text: "Manually Masked UI Item")
			UnmaskedTextFieldView(placeholder: "Manually Unmasked UI Item")
		}
	}

	private var onDemandSessionsSection: some View {
		Section(header: Text("On-demand Sessions")) {
			AsyncButton(text: "Process All On-demand Sessions") {
				DevRev.processAllOnDemandSessions()
				await updateStatuses()
			}
		}
	}

	private var webViewSection: some View {
		Section(header: Text("Web View")) {
			AsyncButton(text: "Open Web View") {
				isWebViewPresented = true
			}
			.sheet(isPresented: $isWebViewPresented) {
				MaskedWebView()
			}
		}
	}

	private var largeScrollableListSection: some View {
		Section(header: Text("Large Scrollable List")) {
			NavigationLink(destination: ListViewScreen()) {
				Text("Open Large Scrollable List")
			}
		}
	}

	private func updateStatuses() async {
		isRecording = DevRev.isRecording
		isMonitoringEnabled = DevRev.isMonitoringEnabled
	}

	private func captureTestError() {
		let error = NSError(
			domain: "ai.devrev.sdk.sample.swiftui",
			code: 1001,
			userInfo: [
				NSLocalizedDescriptionKey: "This is a test error!"
			]
		)

		DevRev.captureError(error, tag: "TestError")
	}
}

struct MaskedLabelView: UIViewRepresentable {
	let text: String

	func makeUIView(context: Context) -> UILabel {
		let label = UILabel()
		label.text = text
		return label
	}

	func updateUIView(_ uiView: UILabel, context: Context) {
		uiView.text = text
		DevRev.markSensitiveViews([uiView])
	}
}

struct UnmaskedTextFieldView: UIViewRepresentable {
	let placeholder: String

	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField()
		textField.placeholder = placeholder
		return textField
	}

	func updateUIView(_ uiView: UITextField, context: Context) {
		DevRev.unmarkSensitiveViews([uiView])
	}
}

struct MaskedImageView: UIViewRepresentable {
	let image: UIImage
	var contentMode: UIView.ContentMode = .scaleAspectFit
	var cornerRadius: CGFloat = 0
	var shadowRadius: CGFloat = 0
	var shadowOpacity: Float = 0
	var shadowOffset: CGSize = .zero
	var shadowColor: UIColor = .black

	func makeUIView(context: Context) -> UIView {
		let containerView = UIView()
		containerView.backgroundColor = .clear

		let imageView = UIImageView()
		imageView.contentMode = contentMode
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = cornerRadius
		imageView.translatesAutoresizingMaskIntoConstraints = false
		containerView.addSubview(imageView)

		if shadowRadius > 0 {
			containerView.layer.shadowColor = shadowColor.cgColor
			containerView.layer.shadowOpacity = shadowOpacity
			containerView.layer.shadowOffset = shadowOffset
			containerView.layer.shadowRadius = shadowRadius
			containerView.layer.masksToBounds = false
		}

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
		])

		context.coordinator.imageView = imageView
		return containerView
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		guard
			let imageView = context.coordinator.imageView
		else {
			return
		}
		imageView.image = image
		DevRev.markSensitiveViews([imageView])
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	class Coordinator {
		var imageView: UIImageView?
	}
}
