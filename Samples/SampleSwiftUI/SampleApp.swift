import Foundation
import SwiftUI

@main
struct SampleApp: App {
	@UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
	
	var body: some Scene {
		WindowGroup {
			HomeView()
		}
	}
}
