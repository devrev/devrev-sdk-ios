import Foundation

// MARK: - Test Constants

enum TestConstants {
	static let testMode = "-test-mode"
	static let appID = "UI_TESTS_APP_ID"

	// MARK: - Devrev Config Flags

	static let disableFrameCapture = "-disable-frame-capture"
	static let disableAutoRecording = "-disable-auto-recording"
	static let disableRemoteConfig = "-disable-remote-config"

	// MARK: - Accessibility Identifiers

	enum AccessibilityID {
		// MARK: - Home Screen

		enum Home {
			static let sdkConfiguredStatus = "home.status.sdkConfigured"
			static let userIdentifiedStatus = "home.status.userIdentified"
			static let monitoringEnabledStatus = "home.status.monitoringEnabled"
			static let identificationLink = "home.feature.identification"
			static let pushNotificationsLink = "home.feature.pushNotifications"
			static let supportLink = "home.feature.support"
			static let sessionAnalyticsLink = "home.feature.sessionAnalytics"
			static let forceCrashButton = "home.debug.forceCrash"
		}

		// MARK: - Identification Screen

		enum Identification {
			static let userIdentifiedStatus = "identification.status.userIdentified"
			static let unverifiedUserIDField = "identification.unverified.userID"
			static let identifyUnverifiedButton = "identification.unverified.identifyButton"
			static let verifiedUserIDField = "identification.verified.userID"
			static let sessionTokenField = "identification.verified.sessionToken"
			static let identifyVerifiedButton = "identification.verified.identifyButton"
			static let emailField = "identification.update.email"
			static let updateUserButton = "identification.update.updateButton"
			static let logoutButton = "identification.logout.button"
		}

		// MARK: - Push Notifications Screen

		enum PushNotifications {
			static let registerButton = "pushNotifications.register"
			static let unregisterButton = "pushNotifications.unregister"
		}

		// MARK: - Support Screen

		enum Support {
			static let userIdentifiedStatus = "support.status.userIdentified"
			static let createConversationButton = "support.createConversation"
			static let showSupportButton = "support.showSupport"
		}

		// MARK: - Session Analytics Screen

		enum SessionAnalytics {
			static let monitoringEnabledStatus = "sessionAnalytics.status.monitoringEnabled"
			static let recordingStatus = "sessionAnalytics.status.recording"
			static let resumeMonitoringButton = "sessionAnalytics.monitoring.resume"
			static let stopMonitoringButton = "sessionAnalytics.monitoring.stop"
			static let startRecordingButton = "sessionAnalytics.recording.start"
			static let stopRecordingButton = "sessionAnalytics.recording.stop"
			static let pauseRecordingButton = "sessionAnalytics.recording.pause"
			static let resumeRecordingButton = "sessionAnalytics.recording.resume"
			static let startTimerButton = "sessionAnalytics.timer.start"
			static let stopTimerButton = "sessionAnalytics.timer.stop"
			static let maskedLabel = "sessionAnalytics.masking.maskedLabel"
			static let unmaskedTextField = "sessionAnalytics.masking.unmaskedTextField"
			static let processSessionsButton = "sessionAnalytics.onDemand.process"
			static let openWebViewButton = "sessionAnalytics.webView.open"
			static let openLargeListLink = "sessionAnalytics.largeList.open"
		}

		// MARK: - Large List Screen

		enum LargeList {
			static let list = "largeList.list"
		}

		// MARK: - Masked Web View Screen

		enum MaskedWebView {
			static let webView = "maskedWebView.webView"
		}
	}
}
