# DevRev SDK for iOS
DevRev SDK, used for integrating DevRev services into your iOS app.

## Table of contents
- [DevRev SDK for iOS](#devrev-sdk-for-ios)
	- [Table of contents](#table-of-contents)
	- [Requirements](#requirements)
	- [Integration](#integration)
		- [Swift Package Manager (Recommended)](#swift-package-manager-recommended)
		- [CocoaPods](#cocoapods)
	- [Setting up the DevRev SDK](#setting-up-the-devrev-sdk)
		- [Step 1: Credentials](#step-1-credentials)
		- [Step 2: Configuration](#step-2-configuration)
				- [Example](#example)
			- [UIKit apps](#uikit-apps)
			- [SwiftUI apps](#swiftui-apps)
	- [Features](#features)
		- [Identification](#identification)
			- [Anonymous identification](#anonymous-identification)
			- [Unverified identification](#unverified-identification)
			- [Updating the user](#updating-the-user)
			- [Examples](#examples)
		- [PLuG support chat](#plug-support-chat)
			- [UIKit](#uikit)
				- [Examples](#examples-1)
			- [SwiftUI](#swiftui)
			- [New conversation closure](#new-conversation-closure)
				- [Example](#example-1)
		- [Analytics](#analytics)
				- [Example](#example-2)
		- [Observability](#observability)
			- [Opting in/out](#opting-inout)
			- [Session recording](#session-recording)
			- [Session properties](#session-properties)
			- [Masking sensitive data](#masking-sensitive-data)
			- [Timers](#timers)
				- [Example](#example-3)
			- [Screen tracking](#screen-tracking)
				- [Example](#example-4)
		- [Push notifications](#push-notifications)
			- [Configuration](#configuration)
			- [Registering for push notifications](#registering-for-push-notifications)
				- [Example](#example-5)
			- [Unregistering from push notifications](#unregistering-from-push-notifications)
				- [Example](#example-6)
			- [Handling push notifications](#handling-push-notifications)
				- [Example](#example-7)
	- [Sample app](#sample-app)
	- [Troubleshooting](#troubleshooting)
		- [Cannot import the SDK into my app](#cannot-import-the-sdk-into-my-app)
		- [How does the DevRev SDK handle errors?](#how-does-the-devrev-sdk-handle-errors)
		- [Why won't the support chat show?](#why-wont-the-support-chat-show)
		- [Why am I not receiving push notifications?](#why-am-i-not-receiving-push-notifications)
	- [License](#license)

## Requirements
- Latest stable Xcode from the [App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12), 16.0 or later.
- Swift 5.9 or later.
- Minimum deployment target iOS 13.

## Integration

The DevRev SDK can be integrated through Swift Package Manager (SPM) or CocooaPods.

> [!NOTE]
> We recommend integrating the DevRev SDK using Swift Package Manager.

### Swift Package Manager (Recommended)

You can integrate the DevRev SDK in your project as a Swift Package Manager (SPM) package.

Open your project in Xcode, go to the `Add Package` screen, add the following URL under `Enter Package URL`:
- HTTPS:
	```
	https://github.com/devrev/devrev-sdk-ios
	```
- or using SSH:
	```
	git@github.com:devrev/devrev-sdk-ios.git
	```

Make sure you link the framework under the **Build Phases** screen of your app target. Find the **Link Binary With Libraries** phase and make sure that **DevRevSDK** is linked there.

Now you should be able to import and use the DevRev SDK.

### CocoaPods

The DevRev SDK can also be integrated using CocoaPods. Add the following line to your `Podfile`:
```
pod 'DevRevSDK', '~> 1.0.0'
```

Then run `pod install` in your project directory.

## Setting up the DevRev SDK
### Step 1: Credentials
1. Open the DevRev web app at [https://app.devrev.ai](https://app.devrev.ai).
1. Go to the **Settings** page.
1. Then open the **PLuG Settings** page, and copy the value under **Your Unique App ID**.

### Step 2: Configuration
> [!IMPORTANT]
> The SDK must be configured before you can use any of its features.

Once you have the credentials, you can configure the DevRev SDK in your app. The SDK will be ready to use once you have called the configuration method:

```swift
DevRev.configure(appID:)
```

##### Example
```swift
DevRev.configure(appID: "abcdefg12345")
```

#### UIKit apps
Configure the SDK in the `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method.

#### SwiftUI apps
Depending on the architecture of your app, you will need to configure the SDK at your entry point or initial view of the app.

## Features
### Identification
Certain features of the DevRev SDK **require** a user identification. There are two methods to identify your users:
- **Anonymous users**: Creates an anonymous user with an optional user identifier, no other data is stored or associated with the user.
- **Unverified users**: Identifies the user with a unique identifier, but does not verify the user's identity with the DevRev backend.

The identification functions should be placed at the appropriate place in your app after you login your user. If you have the user information at app launch, call the function after the `DevRev.configure(appID:)` method.

> [!IMPORTANT]
> If you haven't previously identified the user, the DevRev SDK will automatically create an anonymous user for you right after the SDK has been configured.

> [!IMPORTANT]
> The user, organization and account traits in the `Identity` structure also support custom fields, which need to be configured in the DevRev web app before they can be used. For more information, see [Object customization](https://devrev.ai/docs/product/object-customization).

#### Anonymous identification
The anonymous identification method is used to create an anonymous user with an optional user identifier.

```swift
DevRev.identifyAnonymousUser(userID:)
```

#### Unverified identification
The unverified identification method is used to identify the user with a unique identifier, but does not verify the user's identity with the DevRev backend.

```swift
DevRev.identifyUnverifiedUser(_:)
```

The function accepts the `DevRev.Identity` structure, with the user identifier (`userID`) as the only required property, all other properties are optional.

#### Updating the user
You can update the user's information using the following method:

```swift
DevRev.updateUser(_:)
```

The function accepts the `DevRev.Identity` structure.

> [!IMPORTANT]
> The `userID` property can *not* be updated.

#### Examples

> [!NOTE]
The identification functions are asynchronous, make sure that you wrap them in a `Task` when calling them from synchronous contexts.

```swift
// Identify an anonymous user without a user identifier.
await DevRev.identifyAnonymousUser()

// Identify an unverified user with its email address an user identifier.
await DevRev.identifyUnverifiedUser(Identity(userID: "foo@example.org"))

// Update the user's information.
await DevRev.updateUser(Identity(organizationID: "foo-bar-1337"))
```

### PLuG support chat
#### UIKit
The support chat feature can be shown as a modal screen from a specific view controller or the top-most one, or can be pushed onto a navigation stack.

The following overloaded method will show the support chat screen from a specific view controller or pushed to a navigation stack:
```swift
await DevRev.showSupport(from:isAnimated:)
```

1. When a `UIViewController` is passed as the `from` parameter, then the screen will be shown **modally**.
1. When a `UINavigationController` is passed as the `from` parameter, then the screen will be pushed onto the stack.

If you want to show the support chat screen from the top-most view controller, you can use the following method:
```swift
await DevRev.showSupport(isAnimated:)
```

##### Examples
```swift
/// Push the support chat screen to a navigation stack.
await DevRev.showSupport(from: mainNavigationController)

/// Show the support chat screen modally from a specific view controller.
await DevRev.showSupport(from: settingsViewController)

/// Show the support chat screen from the top-most view controller, without an animation.
await DevRev.showSupport(isAnimated: false)
```

#### SwiftUI
In order to show the support chat screen in a SwiftUI app, you can use the following view:

```swift
DevRev.supportView
```

#### Creating a new conversation
You have the ability to create a new conversation from within your app. The method will show the support chat screen and create a new conversation at the same time.

```swift
DevRev.createConversation()
```

#### New conversation closure
When a new conversation has been created, you can receive a callback using the closure below:

```swift
DevRev.conversationCreatedCompletion
```

That way your app will be able to access the ID of the newly created conversation.

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
The DevRev SDK supports sending custom analytic events using a name and a string dictionary.

You can track them using the following function:
```swift
DevRev.trackEvent(name:properties:)
```

##### Example
```swift
await DevRev.trackEvent(name: "open-message-screen", properties: ["id": "foo-bar-1337"])
```

### Observability
The DevRev SDK provides observability features to help you understand how your users are interacting with your app.

#### Opting in/out
The observability features are opted-in by default, meaning that they are enabled from start.
You can opt-out of the observability features by calling the following method:

```swift
DevRev.stopAllMonitoring()
```

To opt back in, you can call the following method:

```swift
DevRev.resumeAllMonitoring()
```

#### Session recording
You can enable session recording to record user interactions with your app.

> [!CAUTION]
> The session recording feature is opt-out and is enabled by default.

The session recording feature has a number of methods to help you control the recording:

- `DevRev.startRecording()`: Starts the session recording.
- `DevRev.stopRecording()`: Stops the session recording and uploads it to the portal.
- `DevRev.pauseRecording()`: Pauses the ongoing session recording.
- `DevRev.resumeRecording()`: Resumes a paused session recording.
- `DevRev.processAllOnDemandSessions()`: Stops the ongoing user recording and sends all on-demand sessions along with the current recording.

#### Session properties
You can add custom properties to the session recording to help you understand the context of the session. The properties are defined as a dictionary of string values.

```swift
DevRev.addSessionProperties(_:)
```

You also have the ability to clear the session properties in scenarios like user logout or when the session ends.

```swift
DevRev.clearSessionProperties()
```

#### Masking sensitive data
In order to protect sensitive data the DevRev SDK provides an auto-masking feature, which masks the data before it is being sent to the server. Input views such as text fields, text views, and web views are automatically masked.

While the auto-masking mechanism might be sufficient for most cases, you can also manually mark other views as sensitive using the following method:

```swift
DevRev.markSensitiveViews(_:)
```

If any previously masked views need to be unmasked, you can use the following method:

```swift
DevRev.unmarkSensitiveViews(_:)
```

#### Timers
As part of the observability features, the DevRev SDK provides a timer mechanism to help you measure the time spent on a specific task. Events such as response time, loading time, or any other time-based event can be measured using the timer.

The mechanism works using balanced start and stop methods that both accept a timer name and an optional dictionary of properties.

Start a timer using the method:
```swift
DevRev.startTimer(_:properties:)
```

And balance it with the stop method:
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
The DevRev SDK provides automatic screen tracking to help you understand how users are navigating through your app. While view controllers are automatically tracked, you can also manually track screens using the following method:

```swift
DevRev.trackScreenName(_:)
```

##### Example
```swift
DevRev.trackScreenName("profile-screen")
```

### Push notifications
You can configure your app to receive push notifications from the DevRev SDK. The SDK is able to handle push notifications and perform actions based on the content of the notification.

The DevRev backend sends push notifications to your app to notify users about new messages in the PLuG support chat. In the future, the push notification support will be expanded with additional features.

#### Configuration
In order to receive push notifications, you need to configure your DevRev organization by following the [Push Notifications integration guide](#).

You need to make sure that your iOS app is configured to receive push notifications. You can follow the [Apple documentation](https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns) to set up your app to receive push notifications.

#### Registering for push notifications
> [!IMPORTANT]
> Push notifications require that the SDK has been configured and the user has been identified (unverified and anonymous users). The user identification is required to send the push notification to the correct user.

The DevRev SDK provides a method to register your device for receiving push notifications. You can call the following method to register for push notifications:

```swift
DevRev.registerDeviceToken(_:deviceID:)
```

The method requires a device identifier, which might be an identifier unique to your system or the Apple provided vendor identifier (IDFV). The registration is usually called from the `AppDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` method.

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

#### Unregistering from push notifications
In cases when your app no longer wants to receive push notifications, you can unregister the device from receiving them. The method to unregister the device is:

```swift
DevRev.unregisterDevice(_:)
```

The method requires the device identifier, which is the same as the one used for registering the device. The best place to place the method is after you call `UIApplication.unregisterForRemoteNotifications()` in your app.

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

#### Handling push notifications
In order to properly handle push notifications, you need to implement the following method, usually in the `UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:)` or `UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`:

```swift
DevRev.processPushNotification(_:)
```

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
### Cannot import the SDK into my app
Check the [Setup](#setup) again and make sure that the DevRevSDK framework is properly linked.

### How does the DevRev SDK handle errors?
The DevRev SDK outputs all errors in the console using Apple's Unified Logging System under the subsystem `ai.devrev.sdk`.

### Why won't the support chat show?
Make sure you have called one of the identification methods properly (`DevRev.identifyUnverifiedUser(...)` or `DevRev.identifyAnonymousUser(...)`).

### Why am I not receiving push notifications?
Make sure that you have configured your app to receive push notifications and that you have registered your device with the DevRev SDK.

## License
Apache 2.0
