import Foundation
import UIKit
import SwiftUI
import AVFoundation
import AudioToolbox

struct QRScannerView: View {
	private let title = "QR Scanner"
	@SwiftUI.State private var scannedCode: String?

	var body: some View {
		VStack(spacing: 0) {
			if let code = scannedCode {
				ScrollView {
					VStack(spacing: 16) {
						Image(systemName: "qrcode.viewfinder")
							.font(.system(size: 60))
							.foregroundColor(.accentColor)
							.padding(.top, 24)

						Text("Scanned Result")
							.font(.headline)

						Text(code)
							.font(.body)
							.textSelection(.enabled)
							.padding()
							.frame(maxWidth: .infinity)
							.background(
								RoundedRectangle(cornerRadius: 12)
									.fill(Color(uiColor: .secondarySystemBackground))
							)
							.padding(.horizontal, 20)

						Button(
							action: {
								withAnimation(.spring(
									response: 0.3,
									dampingFraction: 0.7
								)) {
									scannedCode = nil
								}
							}
						) {
							Label(
								"Scan Again",
								systemImage: "arrow.clockwise"
							)
								.font(.body.weight(.medium))
								.foregroundColor(.accentColor)
								.padding(.horizontal, 24)
								.padding(.vertical, 12)
								.background(
									RoundedRectangle(cornerRadius: 12)
										.fill(Color.accentColor.opacity(0.1))
								)
						}
						.padding(.bottom, 16)
					}
				}
			}
			else {
				if AVCaptureDevice.default(for: .video) != nil {
					QRScannerCameraView(scannedCode: $scannedCode)
				}
				else {
					EmptyStateView(
						systemImageName: "qrcode.viewfinder",
						title: "Camera Unavailable",
						message: "QR scanning requires a device with a camera"
					)
				}
			}
		}
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct QRScannerCameraView: UIViewControllerRepresentable {
	@Binding var scannedCode: String?

	func makeUIViewController(context: Context) -> QRScannerHostController {
		let controller = QRScannerHostController()
		controller.delegate = context.coordinator
		return controller
	}

	func updateUIViewController(_ uiViewController: QRScannerHostController, context: Context) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, QRScannerHostControllerDelegate {
		let parent: QRScannerCameraView

		init(_ parent: QRScannerCameraView) {
			self.parent = parent
		}

		func didScanCode(_ code: String) {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
				parent.scannedCode = code
			}
		}
	}
}

protocol QRScannerHostControllerDelegate: AnyObject {
	func didScanCode(_ code: String)
}

class QRScannerHostController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	weak var delegate: QRScannerHostControllerDelegate?
	private var captureSession: AVCaptureSession?
	private var previewLayer: AVCaptureVideoPreviewLayer?

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		setupCaptureSession()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		previewLayer?.frame = view.bounds
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		startRunning()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		stopRunning()
	}

	private func setupCaptureSession() {
		let session = AVCaptureSession()

		guard
			let videoCaptureDevice = AVCaptureDevice.default(for: .video),
			let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
			session.canAddInput(videoInput)
		else {
			return
		}

		session.addInput(videoInput)

		let metadataOutput = AVCaptureMetadataOutput()

		guard session.canAddOutput(metadataOutput)
		else {
			return
		}

		session.addOutput(metadataOutput)
		metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
		metadataOutput.metadataObjectTypes = [.qr]

		let preview = AVCaptureVideoPreviewLayer(session: session)
		preview.frame = view.bounds
		preview.videoGravity = .resizeAspectFill
		view.layer.addSublayer(preview)

		captureSession = session
		previewLayer = preview
	}

	private func startRunning() {
		guard let session = captureSession, !session.isRunning
		else {
			return
		}

		DispatchQueue.global(qos: .userInitiated).async {
			session.startRunning()
		}
	}

	private func stopRunning() {
		guard let session = captureSession, session.isRunning
		else {
			return
		}

		DispatchQueue.global(qos: .userInitiated).async {
			session.stopRunning()
		}
	}

	func metadataOutput(
		_ output: AVCaptureMetadataOutput,
		didOutput metadataObjects: [AVMetadataObject],
		from connection: AVCaptureConnection
	) {
		guard
			let metadataObject = metadataObjects.first,
			let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
			let stringValue = readableObject.stringValue
		else {
			return
		}

		AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
		stopRunning()
		delegate?.didScanCode(stringValue)
	}
}

#Preview {
	QRScannerView()
}
