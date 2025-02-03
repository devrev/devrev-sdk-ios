import Foundation
import SwiftUI
import DevRevSDK

struct SessionAnalyticsView: View {
    @SwiftUI.State private var showAlert = false
    @SwiftUI.State private var alertTitle = ""
    @SwiftUI.State private var alertMessage = ""

    var body: some View {
        List {
            Section(header: Text("Track Event")) {
                Button(action: {
                    Task {
                        DevRev.stopAllMonitoring()
                        showAlert(title: "Monitoring Stopped", message: "All monitoring has been stopped.")
                    }
                }) {
                    Text("Stop Monitoring")
                }
                Button(action: {
                    Task {
                        DevRev.resumeAllMonitoring()
                        showAlert(title: "Monitoring Resumed", message: "All monitoring has been resumed.")
                    }
                }) {
                    Text("Resume All Monitoring")
                }
            }
            Section(header: Text("Session Recording")) {
                Button(action: {
                    Task { @MainActor in
                        await DevRev.startRecording()
                        showAlert(title: "Recording Started", message: "Session recording has started.")
                    }
                }) {
                    Text("Start Recording")
                }
                Button(action: {
                    Task {
                        DevRev.stopRecording()
                        showAlert(title: "Recording Stopped", message: "Session recording has stopped.")
                    }
                }) {
                    Text("Stop Recording")
                }
                Button(action: {
                    Task {
                        DevRev.pauseRecording()
                        showAlert(title: "Recording Paused", message: "Session recording has been paused.")
                    }
                }) {
                    Text("Pause Recording")
                }
                Button(action: {
                    Task {
                        DevRev.resumeRecording()
                        showAlert(title: "Recording Resumed", message: "Session recording has been resumed.")
                    }
                }) {
                    Text("Resume Recording")
                }
                Button(action: {
                    Task {
                        DevRev.processAllOnDemandSessions()
                        showAlert(title: "Sessions Processed", message: "All on-demand sessions have been processed.")
                    }
                }) {
                    Text("Process All On-demand Sessions")
                }
            }
        }
        .navigationTitle("Session Analytics")
        .listStyle(InsetGroupedListStyle())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}


