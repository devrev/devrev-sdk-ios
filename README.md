# DevRev SDK for iOS
DevRev SDK, used for integrating DevRev services into your iOS app.

## Table of contents
- [DevRev SDK for iOS](#devrev-sdk-for-ios)
	- [Table of contents](#table-of-contents)
	- [Requirements](#requirements)
	- [Integration](#integration)
		- [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
		- [CocoaPods](#cocoapods)
			- [UIKit apps](#uikit-apps)
			- [SwiftUI apps](#swiftui-apps)
	- [Features](#features)
		- [Identification](#identification)
			- [Anonymous identification](#anonymous-identification)
			- [Unverified identification](#unverified-identification)
			- [Verified identification](#verified-identification)
			- [Updating the user](#updating-the-user)
			- [Logout](#logout)
			- [Examples](#examples)
		- [PLuG support chat](#plug-support-chat)
			- [UIKit](#uikit)
				- [Examples](#examples-1)
			- [SwiftUI](#swiftui)
			- [Creating a new conversation](#creating-a-new-conversation)
			- [New conversation closure](#new-conversation-closure)
				- [Example](#example)
		- [In-app link handling](#in-app-link-handling)
		- [Analytics](#analytics)
				- [Example](#example-1)
		- [Session analytics](#session-analytics)
			- [Opting-in or out](#opting-in-or-out)
			- [Session recording](#session-recording)
			- [Session properties](#session-properties)
			- [Masking sensitive data](#masking-sensitive-data)
			- [Timers](#timers)
				- [Example](#example-2)
			- [Screen tracking](#screen-tracking)
				- [Example](#example-3)
		- [Push notifications](#push-notifications)
			- [Configuration](#configuration)
			- [Register for push notifications](#register-for-push-notifications)
				- [Example](#example-4)
			- [Unregister from push notifications](#unregister-from-push-notifications)
				- [Example](#example-5)
			- [Handle push notifications](#handle-push-notifications)
				- [Example](#example-6)
	- [Sample app](#sample-app)
	- [Troubleshooting](#troubleshooting)

## Requirements
- Xcode 16.0 or higher (latest stable version available on the App Store)
- Swift 5.9 or later
- Set the minimum deployment target for your iOS application as iOS 15

## Integration

The DevRev SDK can be integrated using either Swift Package Manager (SPM) or CocoaPods.

> [!CAUTION]
> We recommend integrating the DevRev SDK using Swift Package Manager. CocoaPods is in [maintenance mode](https://blog.cocoapods.org/CocoaPods-Support-Plans/) since August 2024 and will be [deprecated in the future](https://blog.cocoapods.org/CocoaPods-Specs-Repo/).

### Swift Package Manager (Recommended)

You can integrate the DevRev SDK in your project as a Swift Package Manager (SPM) package.

To integrate the DevRev SDK into your project using SPM:

1. Open your project in Xcode and navigate to the **Add Package Dependency**.
2. Enter the DevRev SDK URL under **Enter Package URL**:
	- For HTTPS: https://github.com/devrev/devrev-sdk-ios
	- For SSH: `git@github.com:devrev/devrev-sdk-ios.git`
3. In the **Build Phases** section of your app target, locate the **Link Binary With Libraries** phase and confirm that `DevRevSDK` is linked. If not, add it by clicking **+** and selecting `DevRevSDK` from the list.

Now you should be able to import and use the DevRev SDK in your project.

### CocoaPods

To integrate the DevRev SDK using CocoaPods:

1. Add the following to your Podfile:
	```ruby
   pod 'DevRevSDK', '~> 1.0.0'
   ```
2. Run `pod install` in your project directory.

This will install the DevRev SDK in your project, making it ready for use.

## Set up the DevRev SDK

1. Open the DevRev web app at [https://app.devrev.ai](https://app.devrev.ai) and go to the **Settings** page.
2. Under **PLuG settings** copy the value under **Your unique App ID**.
3. After obtaining the credentials, you can configure the DevRev SDK in your app.

The SDK will be ready for use once you execute the following configuration method.
```swift
DevRev.configure(appID:)
```
Use this property to check whether the DevRev SDK has been configured:
```swift
await DevRev.isConfigured
```

For example:

```swift
DevRev.configure(appID: "abcdefg12345")
```

#### UIKit apps
Configure the SDK in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method.

#### SwiftUI apps
Depending on your app's architecture, configure the SDK at the app's entry point or initial view.

## Features
### Identification
To access certain features of the DevRev SDK, user identification is required.

The identification function should be placed appropriately in your app after the user logs in. If you have the user information available at app launch, call the function after the `DevRev.configure(appID:)` method.


> [!IMPORTANT]
> If you haven't previously identified the user, the DevRev SDK will automatically create an anonymous user for you immediately after the SDK is configured.

> [!IMPORTANT]
> The `Identity` structure allows for custom fields in the user, organization, and account traits. These fields must be configured through the DevRev app before they can be utilized. For more information, refer to [Object customization](https://devrev.ai/docs/product/object-customization).

#### Anonymous identification
The anonymous identification method allows you to create an anonymous user with an optional user identifier, ensuring that no other data is stored or associated with the user.

```swift
DevRev.identifyAnonymousUser(userID:)
```

#### Unverified identification
The unverified identification method identifies users with a unique identifier, but it does not verify their identity with the DevRev backend.

```swift
DevRev.identifyUnverifiedUser(_:)
```

The function accepts the `DevRev.Identity` structure, with the user identifier (`userID`) as the only required property, all other properties are optional.

#### Verified identification
The verified identification method is used to identify the user with a unique identifier and verify the user's identity with the DevRev backend.

```swift
DevRev.identifyVerifiedUser(_:sessionToken:)
```

#### Updating the user
You can update the user's information using the following method:

```swift
DevRev.updateUser(_:)
```

Use this property to check whether the user is identified in the current session:
```swift
await DevRev.isUserIdentified
```

The function accepts the `DevRev.Identity` structure.

> [!IMPORTANT]
> The `userID` property can *not* be updated.

#### Logout
You can perform a logout of the current user by calling the following method:

```swift
DevRev.logout(deviceID:)
```

The user will be logged out by clearing their credentials, as well as unregistering the device from receiving push notifications, and stopping the session recording.

#### Examples

> [!NOTE]
The identification functions are asynchronous, make sure that you wrap them in a `Task` when calling them from synchronous contexts.

```swift
// Identify an anonymous user without a user identifier.
await DevRev.identifyAnonymousUser()

// Identify an unverified user using their email address as the user identifier.
await DevRev.identifyUnverifiedUser(Identity(userID: "foo@example.org"))

// Identify a verified user using their email address as the user identifier.
await DevRev.identifyVerifiedUser("foo@example.org", sessionToken: "bar-1337")
// Update the user's information.
await DevRev.updateUser(Identity(organizationID: "foo-bar-1337"))
```

### PLuG support chat
#### UIKit
The support chat feature can be shown as a modal screen from a specific view controller or the top-most one, or can be pushed onto a navigation stack. 

To show the support chat screen in your app, you can use the following overloaded method:
```swift
await DevRev.showSupport(from:isAnimated:)
```

- When a `UIViewController` is passed as the `from` parameter, the screen is shown modally.
- When a `UINavigationController` is passed as the `from` parameter, the screen is pushed onto the navigation stack.

If you want to display the support chat screen from the top-most view controller, use the following method:
```swift
await DevRev.showSupport(isAnimated:)
```

##### Examples
```swift
/// When set to true (default), the DevRev UI will adapt theme dynamically to the system appearance.
/// Set this flag to false to force the DevRev UI to use the default theme configured in the DevRev portal.
DevRev.prefersSystemTheme: Bool

/// Push the support chat screen to a navigation stack.
await DevRev.showSupport(from: mainNavigationController)

/// Show the support chat screen modally from a specific view controller.
await DevRev.showSupport(from: settingsViewController)

/// Show the support chat screen from the top-most view controller, without an animation.
await DevRev.showSupport(isAnimated: false)
```

#### SwiftUI
To display the support chat screen in a SwiftUI app, you can use the following view:

```swift
DevRev.supportView
```

#### Creating a new conversation
You have the ability to create a new conversation from within your app. The method will show the support chat screen and create a new conversation at the same time.

```swift
DevRev.createSupportConversation()
```

#### New conversation closure
You can receive a callback when a new conversation is created by setting the following closure:

```swift
DevRev.conversationCreatedCompletion
```

This allows your app to access the ID of the newly created conversation.

##### Example
```swift
DevRev.conversationCreatedCompletion = { conversationID in
	print("A new conversation has been created: \(conversationID).")
}
```

### In-app link handling
The DevRev SDK provides a mechanism to handle links opened from within any screen that is part of the DevRev SDK.

You can fully customize the link handling behavior by setting the specialized in-app link handler. That way you can decide what should happen when a link is opened from within the app.

```swift
DevRev.inAppLinkHandler: ((URL) -> Void)?
```

You can further customize the behavior by setting the `shouldDismissModalsOnOpenLink` boolean flag. This flag controls whether the DevRev SDK should dismiss the top-most modal screen when a link is opened.

```swift
DevRev.shouldDismissModalsOnOpenLink: Bool
```

### Analytics
The DevRev SDK allows you to send custom analytic events by using a name and a string dictionary. You can track these events using the following function:
```swift
DevRev.trackEvent(name:properties:)
```

##### Example
```swift
await DevRev.trackEvent(name: "open-message-screen", properties: ["id": "foo-bar-1337"])
```

### Session analytics
The DevRev SDK provides observability features to help you understand how your users are interacting with your app.

#### Opting-in or out
Session analytics features are opted-in by default, enabling them from the start. However, you can opt-out using the following method:
```swift
DevRev.stopAllMonitoring()
```

To opt back in, use the following method:

```swift
DevRev.resumeAllMonitoring()
```

You can check whether session monitoring has been enabled by using this property:
```swift
DevRev.isMonitoringEnabled
```

#### Session recording
You can enable session recording to capture user interactions with your app.

> [!CAUTION]
> The session recording feature is opt-out and is enabled by default.

The session recording feature includes the following methods to control the recording:
|Method|Action|
|-|-|
|`DevRev.startRecording()`|Starts the session recording.|
|`DevRev.stopRecording()`|Ends the session recording and uploads it to the portal.|
|`DevRev.pauseRecording()`|Pauses the ongoing session recording.|
|`DevRev.resumeRecording()`|Resumes a paused session recording.|
|`DevRev.processAllOnDemandSessions()`| Stops the ongoing user recording and sends all on-demand sessions along with the current recording. |

Using this property will return the status of the session recording:
```swift
DevRev.isRecording
```

To check if on-demand sessions are enabled, use:
```swift
DevRev.areOnDemandSessionsEnabled
```

#### Session properties
You can add custom properties to the session recording to help you understand the context of the session. The properties are defined as a dictionary of string values.

```swift
DevRev.addSessionProperties(_:)
```

To clear the session properties in scenarios such as user logout or when the session ends, use the following method:

```swift
DevRev.clearSessionProperties()
```

#### Masking sensitive data
To protect sensitive data, the DevRev SDK provides an auto-masking feature that masks data before sending to the server. Input views such as text fields, text views, and web views are automatically masked.

While the auto-masking feature may be sufficient for most situations, you can manually mark additional views as sensitive using the following method:

```swift
DevRev.markSensitiveViews(_:)
```

If any previously masked views need to be unmasked, you can use the following method:

```swift
DevRev.unmarkSensitiveViews(_:)
```

#### Timers
The DevRev SDK offers a timer mechanism to measure the time spent on specific tasks, allowing you to track events such as response time, loading time, or any other duration-based metrics.

The mechanism works using balanced start and stop methods that both accept a timer name and an optional dictionary of properties.

To start a timer, use the following method:
```swift
DevRev.startTimer(_:properties:)
```

To stop a timer, use the following method:
```swift
DevRev.stopTimer(_:properties:)
```

##### Example
```swift
DevRev.startTimer("response-time", properties: ["id": "foo-bar-1337"])

// Perform the task that you want to measure.

DevRev.stopTimer("response-time", properties: ["id": "foo-bar-1337"])
```

#### Screen tracking
The DevRev SDK offers automatic screen tracking to help you understand how users navigate through your app. Although view controllers are automatically tracked, you can manually track screens using the following method:

```swift
DevRev.trackScreenName(_:)
```

##### Example
```swift
DevRev.trackScreenName("profile-screen")
```

### Push notifications
You can configure your app to receive push notifications from the DevRev SDK. The SDK is designed to handle push notifications and execute actions based on the notification's content.

The DevRev backend sends push notifications to your app to notify users about new messages in the PLuG support chat.

#### Configuration
To receive push notifications, you need to configure your DevRev organization by following the instructions in the [push notifications](https://developer.devrev.ai/public/sdks/mobile/push-notification) section.

You need to ensure that your iOS app is configured to receive push notifications. You can follow the [Apple documentation](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns) for guidance on registering your app with Apple Push Notification Service (APNs).

#### Register for push notifications
> [!IMPORTANT]
> Push notifications require that the SDK has been configured and the user has been identified (unverified and anonymous users). The user identification is required to send the push notification to the correct user.

The DevRev SDK offers a method to register your device for receiving push notifications. You can register for push notifications using the following method:

```swift
DevRev.registerDeviceToken(_:deviceID:)
```

The method requires a device identifier, which can either be an identifier unique to your system or the Apple-provided Vendor Identifier (IDFV). Typically, the token registration is called from the `AppDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` method.

##### Example
```swift
func application(
	_ application: UIApplication,
	didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
) {
	guard
		let deviceID = UIDevice.current.identifierForVendor?.uuidString
	else {
		return
	}

	Task {
		await DevRev.registerDeviceToken(
			deviceToken,
			deviceID: deviceID
		)
	}
}
```

#### Unregister from push notifications
If your app no longer needs to receive push notifications, you can unregister the device.

Use the following method to unregister the device:

```swift
DevRev.unregisterDevice(_:)
```

This method requires the device identifier, which should be the same as the one used during registration. It is recommended to place this method after calling `UIApplication.unregisterForRemoteNotifications()` in your app.

##### Example
```swift
UIApplication.shared.unregisterForRemoteNotifications()

Task {
	guard
		let deviceID = UIDevice.current.identifierForVendor?.uuidString
	else {
		return
	}

	await DevRev.unregisterDevice(deviceID)
}
```

#### Handle push notifications
Push notifications coming to the DevRev SDK need to be handled manually. To properly handle them, implement the following method, typically in either the `UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:)` or `UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`:

```swift
DevRev.processPushNotification(_:)
```

> [!IMPORTANT]
> For convenience, this method provides two overloads that accept `userInfo` as either `[AnyHashable: Any]` or `[String: any Sendable]` dictionary types.

##### Example
```swift
func userNotificationCenter(
	_ center: UNUserNotificationCenter,
	didReceive response: UNNotificationResponse
) async {
	await DevRev.processPushNotification(response.notification.request.content.userInfo)
}
```

## Sample app
A sample app with use cases for both UIKit and SwiftUI has been provided as part of this repository.

Before you start using the sample app you will need to configure it to be used with your Apple Developer team and your DevRev credentials. For your convenience the code has been marked with compiler error directives (`#error`) at the places that need attention.

1. Add your credentials to `ContentView.swift` (SwiftUI) or `AppDelegate.swift` (UIKit).
   - After you have added the credentials, delete or comment out the compiler error lines in the respective files.
1. Configure the code signing for the sample target:
	- Open the project settings (1),
	- Select the appropriate target (2),
	- Go to the Signing & Capabilities section (3), and
	- Select your development team under Team (4).
	<img src="docs/screenshots/screenshot-xcode-signing.png" width="400" />

## Troubleshooting
- **Issue**: Can't import the SDK into my app.
	**Solution**: Double-check the setup process and ensure that `DevRevSDK` is correctly linked to your application.

- **Issue**: How does the DevRev SDK handle errors?
	**Solution**: The DevRev SDK reports all errors in the console using Apple's Unified Logging System. Look for error messages in the subsystem `ai.devrev.sdk`.

- **Issue**: Support chat won't show.
	**Solution**: Ensure you have correctly called one of the identification methods: `DevRev.identifyUnverifiedUser(...)`, `DevRev.identifyVerifiedUser(...)`, or `DevRev.identifyAnonymousUser(...)`.

- **Issue**: Not receiving push notifications.
	**Solution**: Ensure that your app is configured to receive push notifications and that your device is registered with the DevRev SDK.
