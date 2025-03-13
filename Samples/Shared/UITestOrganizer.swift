import Foundation

public class UITestOrganizer: NSObject {
	// MARK: - Properties

	public var isInTestMode: Bool {
		processInfo.arguments.contains(TestConstants.testMode)
	}

	public var appID: String? {
		processInfo.environment[TestConstants.appID]
	}

	private let processInfo: ProcessInfo

	// MARK: - Lifecycle

	public init(processInfo: ProcessInfo = .processInfo) {
		self.processInfo = processInfo
	}
}
