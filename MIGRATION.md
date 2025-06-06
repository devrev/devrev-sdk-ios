# Migration Guide
This guide and chart should help facilitate the transition from the legacy UserExperior SDK to the new DevRev SDK in your iOS application, providing insights into feature equivalents and method changes.

## Feature Equivalence Chart

| Feature | UserExperior SDK | DevRev SDK |
|-|-|-|
| Installation | `pod 'UserExperior', '~> <version>` | SPM: `https://github.com/devrev/devrev-sdk-ios`<br />CocoaPods: `pod 'DevRevSDK', '~> <version>` |
| Initialization | `UserExperior.startRecording(_ versionKey: String)` | `DevRev.configure(appID: String)` |
| User Identification | `UserExperior.setUserIdentifier(_ userIdentifier: String)` | `DevRev.identifyAnonymousUser(userID: String)`<br />`DevRev.identifyUnverifiedUser(_ identity: Identity)`<br />`DevRev.updateUser(_ identity: Identity)`<br /> `identifyVerifiedUser( _ userID: String, sessionToken: String)`<br />`DevRev.logout(deviceID: String)` |
| Event Tracking | `UserExperior.logEvent(_ eventName: String)` | `DevRev.trackEvent(name: String, properties: [String: String])` |
| Session Recording | `UserExperior.stopRecording()`<br />`UserExperior.pauseRecording()`<br />`UserExperior.resumeRecording()` | `DevRev.startRecording()`<br />`DevRev.stopRecording()`<br />`DevRev.pauseRecording()`<br />`DevRev.resumeRecording()`<br />`DevRev.processAllOnDemandSessions()` |
| Opting in/out | `UserExperior.consentOptIn()`<br />`UserExperior.consentOptOut()`<br />`UserExperior.getConsentStatus`<br />`UserExperior.getOptOutStatus` | `DevRev.stopAllMonitoring()`<br />`DevRev.resumeAllMonitoring()` |
| Session Properties | `UserExperior.setUserProperties(_ properties: [String: Any])` | `DevRev.addSessionProperties(properties: [String: String])`<br />`DevRev.clearSessionProperties()` |
| Masking Sensitive Data | `UserExperior.markSensitiveViews(_ viewsToSecure: NSArray)`<br />`UserExperior.unmarkSensitiveViews(_ viewsToSecure: NSArray)` | `DevRev.markSensitiveViews(_ sensitiveViews: [UIView])`<br />`DevRev.unmarkSensitiveViews(_ sensitiveViews: [UIView])` |
| Timers | `UserExperior.startTimer(_ timerName: String)`<br />`UserExperior.endTimer(_ timerName: String)` | `DevRev.startTimer(_ name: String, properties: [String: String])`<br />`DevRev.stopTimer(_ name: String, properties: [String: String])` |
| PLuG support chat | Not supported. | `DevRev.showSupport(isAnimated: Bool)`<br />`DevRev.showSupport(from parentViewController: UIViewController,  isAnimated: Bool)`<br />`DevRev.showSupport(from navigationController: UINavigationController,  isAnimated: Bool)`<br />`DevRev.createSupportConversation(isAnimated: Bool)`<br />`DevRev.shouldDismissModalsOnOpenLink`<br />`DevRev.inAppLinkHandler` |
| Push Notifications | Not supported. | `DevRev.registerDeviceToken(_ deviceToken: Data, deviceID: String)`<br />`DevRev.processPushNotification(_ userInfo: [String: String])` |
