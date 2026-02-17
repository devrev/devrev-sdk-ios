import Foundation
import UIKit
import DevRevSDK

class CameraViewController: UIViewController {
	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private let imageShadowContainerView = UIView()
	private let imageView = UIImageView()
	private let emptyStateView = EmptyStateView(
		systemImageName: "camera.fill",
		title: NSLocalizedString("No Photo Captured", comment: ""),
		message: NSLocalizedString("Tap the button below to capture a photo", comment: "")
	)
	private let clearButton = UIButton(type: .system)
	private let buttonContainerView = UIView()
	private let openButton = UIButton(type: .system)

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Camera", comment: "")
		view.backgroundColor = .systemBackground

		setupScrollView()
		setupEmptyState()
		setupImageView()
		setupClearButton()
		setupButtonContainer()
		updateUI()
	}

	private func setupScrollView() {
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(scrollView)

		contentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(contentView)

		NSLayoutConstraint.activate(
			[
				scrollView.topAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.topAnchor
				),
				scrollView.leadingAnchor.constraint(
					equalTo: view.leadingAnchor
				),
				scrollView.trailingAnchor.constraint(
					equalTo: view.trailingAnchor
				),
				scrollView.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor,
					constant: -80
				),
				contentView.topAnchor.constraint(
					equalTo: scrollView.topAnchor
				),
				contentView.leadingAnchor.constraint(
					equalTo: scrollView.leadingAnchor
				),
				contentView.trailingAnchor.constraint(
					equalTo: scrollView.trailingAnchor
				),
				contentView.bottomAnchor.constraint(
					equalTo: scrollView.bottomAnchor
				),
				contentView.widthAnchor.constraint(
					equalTo: scrollView.widthAnchor
				),
			]
		)
	}

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

	private func setupImageView() {
		imageShadowContainerView.layer.shadowColor = UIColor.black.cgColor
		imageShadowContainerView.layer.shadowOpacity = 0.1
		imageShadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 5)
		imageShadowContainerView.layer.shadowRadius = 10
		imageShadowContainerView.layer.masksToBounds = false
		imageShadowContainerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(imageShadowContainerView)

		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 16
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageShadowContainerView.addSubview(imageView)

		NSLayoutConstraint.activate(
			[
				imageShadowContainerView.topAnchor.constraint(
					equalTo: contentView.topAnchor,
					constant: 16
				),
				imageShadowContainerView.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: 16
				),
				imageShadowContainerView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -16
				),
				imageShadowContainerView.heightAnchor.constraint(
					greaterThanOrEqualToConstant: 200
				),

				imageView.topAnchor.constraint(
					equalTo: imageShadowContainerView.topAnchor
				),
				imageView.leadingAnchor.constraint(
					equalTo: imageShadowContainerView.leadingAnchor
				),
				imageView.trailingAnchor.constraint(
					equalTo: imageShadowContainerView.trailingAnchor
				),
				imageView.bottomAnchor.constraint(
					equalTo: imageShadowContainerView.bottomAnchor
				),
			]
		)
	}

	private func setupClearButton() {
		var config = UIButton.Configuration.plain()
		config.image = UIImage(systemName: "trash")
		config.imagePadding = 8
		config.title = NSLocalizedString("Clear Photo", comment: "")
		config.baseForegroundColor = .systemRed
		config.background.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
		config.background.cornerRadius = 12
		config.contentInsets = NSDirectionalEdgeInsets(
			top: 12,
			leading: 24,
			bottom: 12,
			trailing: 24
		)

		clearButton.configuration = config
		clearButton.addTarget(
			self,
			action: #selector(clearPhoto),
			for: .touchUpInside
		)
		clearButton.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(clearButton)

		NSLayoutConstraint.activate(
			[
				clearButton.topAnchor.constraint(
					equalTo: imageShadowContainerView.bottomAnchor,
					constant: 16
				),
				clearButton.centerXAnchor.constraint(
					equalTo: contentView.centerXAnchor
				),
				clearButton.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor,
					constant: -16
				),
			]
		)
	}

	private func setupButtonContainer() {
		buttonContainerView.backgroundColor = .systemBackground
		buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonContainerView)

		let separator = UIView()
		separator.backgroundColor = .separator
		separator.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.addSubview(separator)

		var config = UIButton.Configuration.filled()
		config.image = UIImage(systemName: "camera")
		config.imagePadding = 12
		config.title = NSLocalizedString("Open Camera", comment: "")
		config.cornerStyle = .medium
		config.baseBackgroundColor = .systemBlue
		config.baseForegroundColor = .white
		config.contentInsets = NSDirectionalEdgeInsets(
			top: 16,
			leading: 0,
			bottom: 16,
			trailing: 0
		)

		openButton.configuration = config
		openButton.addTarget(
			self,
			action: #selector(openCamera),
			for: .touchUpInside
		)
		openButton.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.addSubview(openButton)

		NSLayoutConstraint.activate(
			[
				buttonContainerView.leadingAnchor.constraint(
					equalTo: view.leadingAnchor
				),
				buttonContainerView.trailingAnchor.constraint(
					equalTo: view.trailingAnchor
				),
				buttonContainerView.bottomAnchor.constraint(
					equalTo: view.safeAreaLayoutGuide.bottomAnchor
				),
				buttonContainerView.heightAnchor.constraint(
					equalToConstant: 80
				),

				separator.topAnchor.constraint(
					equalTo: buttonContainerView.topAnchor
				),
				separator.leadingAnchor.constraint(
					equalTo: buttonContainerView.leadingAnchor
				),
				separator.trailingAnchor.constraint(
					equalTo: buttonContainerView.trailingAnchor
				),
				separator.heightAnchor.constraint(
					equalToConstant: 0.5
				),

				openButton.leadingAnchor.constraint(
					equalTo: buttonContainerView.leadingAnchor,
					constant: 20
				),
				openButton.trailingAnchor.constraint(
					equalTo: buttonContainerView.trailingAnchor,
					constant: -20
				),
				openButton.topAnchor.constraint(
					equalTo: buttonContainerView.topAnchor,
					constant: 16
				),
			]
		)
	}

	private func updateUI() {
		let hasImage = imageView.image != nil
		emptyStateView.isHidden = hasImage
		imageShadowContainerView.isHidden = !hasImage
		clearButton.isHidden = !hasImage
	}

	@objc private func openCamera() {
		guard UIImagePickerController.isSourceTypeAvailable(.camera)
		else {
			let alert = UIAlertController(
				title: NSLocalizedString(
					"Unavailable",
					comment: ""
				),
				message: NSLocalizedString(
					"Camera is not available on this device",
					comment: ""
				),
				preferredStyle: .alert
			)
			alert.addAction(
				UIAlertAction(
					title: NSLocalizedString("OK", comment: ""),
					style: .default
				)
			)

			present(alert, animated: true)
			return
		}

		let picker = UIImagePickerController()
		picker.sourceType = .camera
		picker.delegate = self
		present(picker, animated: true)
	}

	@objc private func clearPhoto() {
		UIView.animate(withDuration: 0.3, animations: {
			self.imageView.alpha = 0
			self.clearButton.alpha = 0
		}) { _ in
			self.imageView.image = nil
			self.imageView.alpha = 1
			self.clearButton.alpha = 1
			self.updateUI()
		}
	}
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
	) {
		picker.dismiss(animated: true)

		if let image = info[.originalImage] as? UIImage {
			let maxPixelWidth = view.bounds.width * UIScreen.main.scale
			let resizedImage = image.downsized(toFit: maxPixelWidth)

			UIView.transition(
				with: view,
				duration: 0.3,
				options: .transitionCrossDissolve,
				animations: {
					self.imageView.image = resizedImage
					DevRev.markSensitiveViews([self.imageView])
					self.updateUI()
				}
			)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}
}
