# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-02-25

### Fixed
- Improved the stability of the on-demand sessions feature.

## [1.1.0] - 2025-02-18

### Added
- Introducing a logout mechanism that clears the user's credentials, unregisters the device from receiving push notifications, and stops the session recording.
- Added a boolean flag to check if the SDK has been configured.
- Added a boolean flag to check if the user has been identified.
- Added a boolean flag to check if the session is being recorded.
- Added a boolean flag to check if the monitoring is enabled.
- Added a boolean flag to check if the on-demand sessions are enabled.

## [1.0.3] - 2025-02-03

### Fixed
- Fixed an issue where an already identified user could not be switched with a new user of the same type.

### Deprecated
- This version drops support for iOS versions below 15.

## [1.0.2] - 2025-01-13

### Fixed
- Fixed an issue with the verified user identification.

## [1.0.1] - 2025-01-03

### Changed
- Improved the user identification mechanism.

## [1.0.0] - 2024-12-18

### Added
- Introducing the Session Analytics feature. This feature allows you to monitor the health of your application and its components.
- Added support for Push Notifications for the PLuG support chat.
- Added support for on-demand (offline) sessions.
- Added support to create new conversations in the PLuG support chat.
- Added support for in-app link handling.
