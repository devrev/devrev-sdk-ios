import Foundation

public class UITestOrganizer: NSObject {
	// MARK: - Properties

	public var isInTestMode: Bool {
		processInfo.arguments.contains(TestConstants.testMode)
	}

	public var appID: String? {
		processInfo.environment[TestConstants.appID]
	}

	public var shouldDisableFrameCapture: Bool {
		processInfo.arguments.contains(TestConstants.disableFrameCapture)
	}

	public var shouldDisableAutoRecording: Bool {
		processInfo.arguments.contains(TestConstants.disableAutoRecording)
	}

	public var shouldDisableRemoteConfig: Bool {
		processInfo.arguments.contains(TestConstants.disableRemoteConfig)
	}

	private let processInfo: ProcessInfo

	// MARK: - Lifecycle

	public init(processInfo: ProcessInfo = .processInfo) {
		self.processInfo = processInfo
	}
}
