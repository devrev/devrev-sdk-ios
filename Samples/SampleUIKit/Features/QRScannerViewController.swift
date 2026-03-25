import Foundation
import UIKit
import AVFoundation
import AudioToolbox

class QRScannerViewController: UIViewController {
	private let emptyStateView = EmptyStateView(
		systemImageName: "qrcode.viewfinder",
		title: NSLocalizedString("Camera Unavailable", comment: ""),
		message: NSLocalizedString(
			"QR scanning requires a device with a camera",
			comment: ""
		)
	)

	private var captureSession: AVCaptureSession?
	private var previewLayer: AVCaptureVideoPreviewLayer?

	private let resultContainerView = UIScrollView()
	private let resultContentView = UIView()
	private let resultIconImageView = UIImageView()
	private let resultTitleLabel = UILabel()
	private let resultTextBackground = UIView()
	private let resultTextLabel = UILabel()
	private let scanAgainButton = UIButton(type: .system)

	// MARK: - QR scanner lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("QR Scanner", comment: "")
		view.backgroundColor = .systemBackground

		setupEmptyState()
		setupResultsView()
		setupCaptureSession()
		updateUI(scannedCode: nil)
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

	// MARK: - Setup the views

	private func setupEmptyState() {
		view.addSubview(emptyStateView)

		NSLayoutConstraint.activate(
			[
				emptyStateView.centerXAnchor.constraint(
					equalTo: view.centerXAnchor
				),
				emptyStateView.centerYAnchor.constraint(
					equalTo: view.centerYAnchor,
					constant: -40
				),
				emptyStateView.leadingAnchor.constraint(
					greaterThanOrEqualTo: view.leadingAnchor
				),
				emptyStateView.trailingAnchor.constraint(
					lessThanOrEqualTo: view.trailingAnchor
				),
			]
		)
	}

	private func setupResultsView() {
		resultContainerView.translatesAutoresizingMaskIntoConstraints = false
		resultContainerView.isHidden = true
		view.addSubview(resultContainerView)

		resultContentView.translatesAutoresizingMaskIntoConstraints = false
		resultContainerView.addSubview(resultContentView)

		setupResultSubviews()
		setupResultConstraints()
	}

	private func setupResultSubviews() {
		let iconConfig = UIImage.SymbolConfiguration(
			pointSize: 60,
			weight: .regular
		)
		resultIconImageView.image = UIImage(
			systemName: "qrcode.viewfinder",
			withConfiguration: iconConfig
		)
		resultIconImageView.tintColor = .systemBlue
		resultIconImageView.contentMode = .scaleAspectFit
		resultIconImageView.translatesAutoresizingMaskIntoConstraints = false
		resultContentView.addSubview(resultIconImageView)

		resultTitleLabel.text = NSLocalizedString("Scanned Result", comment: "")
		resultTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
		resultTitleLabel.textAlignment = .center
		resultTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		resultContentView.addSubview(resultTitleLabel)

		resultTextBackground.backgroundColor = .secondarySystemBackground
		resultTextBackground.layer.cornerRadius = 12
		resultTextBackground.translatesAutoresizingMaskIntoConstraints = false
		resultContentView.addSubview(resultTextBackground)

		resultTextLabel.font = .systemFont(ofSize: 15)
		resultTextLabel.textAlignment = .center
		resultTextLabel.numberOfLines = 0
		resultTextLabel.translatesAutoresizingMaskIntoConstraints = false
		resultTextBackground.addSubview(resultTextLabel)

		var config = UIButton.Configuration.plain()
		config.image = UIImage(systemName: "arrow.clockwise")
		config.imagePadding = 8
		config.title = NSLocalizedString("Scan Again", comment: "")
		config.baseForegroundColor = .systemBlue
		config.background.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
		config.background.cornerRadius = 12
		config.contentInsets = NSDirectionalEdgeInsets(
			top: 12,
			leading: 24,
			bottom: 12,
			trailing: 24
		)

		scanAgainButton.configuration = config
		scanAgainButton.addTarget(
			self,
			action: #selector(scanAgain),
			for: .touchUpInside
		)
		scanAgainButton.translatesAutoresizingMaskIntoConstraints = false
		resultContentView.addSubview(scanAgainButton)
	}

	private func setupResultConstraints() {
		NSLayoutConstraint.activate(
			[
				resultContainerView.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor
				),
				resultContainerView.leadingAnchor.constraint(
					equalTo: view.leadingAnchor
				),
				resultContainerView.trailingAnchor.constraint(
					equalTo: view.trailingAnchor
				),
				resultContainerView.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor
				),

				resultContentView.topAnchor.constraint(
					equalTo: resultContainerView.topAnchor
				),
				resultContentView.leadingAnchor.constraint(
					equalTo: resultContainerView.leadingAnchor
				),
				resultContentView.trailingAnchor.constraint(
					equalTo: resultContainerView.trailingAnchor
				),
				resultContentView.bottomAnchor.constraint(
					equalTo: resultContainerView.bottomAnchor
				),
				resultContentView.widthAnchor.constraint(
					equalTo: resultContainerView.widthAnchor
				),

				resultIconImageView.topAnchor.constraint(
					equalTo: resultContentView.topAnchor,
					constant: 24
				),
				resultIconImageView.centerXAnchor.constraint(
					equalTo: resultContentView.centerXAnchor
				),

				resultTitleLabel.topAnchor.constraint(
					equalTo: resultIconImageView.bottomAnchor,
					constant: 16
				),
				resultTitleLabel.centerXAnchor.constraint(
					equalTo: resultContentView.centerXAnchor
				),

				resultTextBackground.topAnchor.constraint(
					equalTo: resultTitleLabel.bottomAnchor,
					constant: 16
				),
				resultTextBackground.leadingAnchor.constraint(
					equalTo: resultContentView.leadingAnchor,
					constant: 20
				),
				resultTextBackground.trailingAnchor.constraint(
					equalTo: resultContentView.trailingAnchor,
					constant: -20
				),

				resultTextLabel.topAnchor.constraint(
					equalTo: resultTextBackground.topAnchor,
					constant: 16
				),
				resultTextLabel.leadingAnchor.constraint(
					equalTo: resultTextBackground.leadingAnchor,
					constant: 16
				),
				resultTextLabel.trailingAnchor.constraint(
					equalTo: resultTextBackground.trailingAnchor,
					constant: -16
				),
				resultTextLabel.bottomAnchor.constraint(
					equalTo: resultTextBackground.bottomAnchor,
					constant: -16
				),

				scanAgainButton.topAnchor.constraint(
					equalTo: resultTextBackground.bottomAnchor,
					constant: 16
				),
				scanAgainButton.centerXAnchor.constraint(
					equalTo: resultContentView.centerXAnchor
				),
				scanAgainButton.bottomAnchor.constraint(
					equalTo: resultContentView.bottomAnchor,
					constant: -16
				),
			]
		)
	}

	private func setupCaptureSession() {
		guard
			let videoCaptureDevice = AVCaptureDevice.default(for: .video),
			let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice)
		else {
			return
		}

		let session = AVCaptureSession()

		guard session.canAddInput(videoInput)
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
		view.layer.insertSublayer(preview, at: 0)

		captureSession = session
		previewLayer = preview
	}

	private func updateUI(scannedCode: String?) {
		let hasCamera = captureSession != nil
		let hasResult = scannedCode != nil

		emptyStateView.isHidden = hasCamera || hasResult
		resultContainerView.isHidden = !hasResult
		previewLayer?.isHidden = hasResult

		if let code = scannedCode {
			resultTextLabel.text = code
		}
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

	@objc private func scanAgain() {
		UIView.transition(
			with: view,
			duration: 0.3,
			options: .transitionCrossDissolve,
			animations: {
				self.updateUI(scannedCode: nil)
			}
		)
		startRunning()
	}
}

// MARK: - QR code detection

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
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

		UIView.transition(
			with: view,
			duration: 0.3,
			options: .transitionCrossDissolve,
			animations: {
				self.updateUI(scannedCode: stringValue)
			}
		)
	}
}
