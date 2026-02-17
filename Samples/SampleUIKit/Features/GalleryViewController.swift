import Foundation
import UIKit
import PhotosUI
import DevRevSDK

class GalleryViewController: UIViewController {
	private var collectionView: UICollectionView?
	private let emptyStateView = EmptyStateView(
		systemImageName: "photo.on.rectangle.angled",
		title: NSLocalizedString("No Photos Selected", comment: ""),
		message: NSLocalizedString("Tap the button below to select photos from your gallery", comment: "")
	)
	private let buttonContainerView = UIView()
	private let buttonStackView = UIStackView()
	private let selectButton = UIButton(type: .system)
	private let clearButton = UIButton(type: .system)
	private var selectedImages: [UIImage] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		title = NSLocalizedString("Gallery", comment: "")
		view.backgroundColor = .systemBackground

		setupCollectionView()
		setupEmptyState()
		setupButtonContainer()
		updateUI()
	}

	private func setupCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 8
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

		let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collection.backgroundColor = .systemBackground
		collection.translatesAutoresizingMaskIntoConstraints = false
		collection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
		collection.dataSource = self
		collection.delegate = self
		view.addSubview(collection)
		collectionView = collection

		NSLayoutConstraint.activate([
			collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
		])
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		updateCollectionViewLayout()
	}

	private func updateCollectionViewLayout() {
		guard
			let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
		else {
			return
		}

		let width = view.bounds.width
		let itemsPerRow: CGFloat

		if width > 768 {
			itemsPerRow = 4
		}
		else if width > 414 {
			itemsPerRow = 3
		}
		else {
			itemsPerRow = 2
		}

		let padding: CGFloat = 8
		let sectionPadding: CGFloat = 16
		let totalPadding = (padding * (itemsPerRow - 1)) + (sectionPadding * 2)
		let itemWidth = (width - totalPadding) / itemsPerRow
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
	}

	private func setupEmptyState() {
		view.addSubview(emptyStateView)

		NSLayoutConstraint.activate([
			emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
			emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
			emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
		])
	}

	private func setupButtonContainer() {
		buttonContainerView.backgroundColor = .systemBackground
		buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(buttonContainerView)

		let separator = UIView()
		separator.backgroundColor = .separator
		separator.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.addSubview(separator)

		buttonStackView.axis = .horizontal
		buttonStackView.spacing = 12
		buttonStackView.alignment = .fill
		buttonStackView.distribution = .fill
		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		buttonContainerView.addSubview(buttonStackView)

		var selectConfig = UIButton.Configuration.filled()
		selectConfig.image = UIImage(systemName: "photo.on.rectangle")
		selectConfig.imagePadding = 8
		selectConfig.title = NSLocalizedString("Select Photos", comment: "")
		selectConfig.cornerStyle = .medium
		selectConfig.baseBackgroundColor = .systemBlue
		selectConfig.baseForegroundColor = .white
		selectConfig.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)

		selectButton.configuration = selectConfig
		selectButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
		buttonStackView.addArrangedSubview(selectButton)

		var clearConfig = UIButton.Configuration.plain()
		clearConfig.image = UIImage(systemName: "trash")
		clearConfig.imagePadding = 8
		clearConfig.title = NSLocalizedString("Clear", comment: "")
		clearConfig.cornerStyle = .medium
		clearConfig.baseForegroundColor = .systemRed
		clearConfig.background.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
		clearConfig.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

		clearButton.configuration = clearConfig
		clearButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
		clearButton.isHidden = true
		buttonStackView.addArrangedSubview(clearButton)

		selectButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
		clearButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

		NSLayoutConstraint.activate([
			buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			buttonContainerView.heightAnchor.constraint(equalToConstant: 80),

			separator.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
			separator.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
			separator.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
			separator.heightAnchor.constraint(equalToConstant: 0.5),

			buttonStackView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor, constant: 20),
			buttonStackView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -20),
			buttonStackView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 16),
		])
	}

	private func updateUI() {
		let hasImages = !selectedImages.isEmpty
		emptyStateView.isHidden = hasImages
		collectionView?.isHidden = !hasImages

		if hasImages {
			let photoText = selectedImages.count == 1 ? NSLocalizedString(
				"photo",
				comment: ""
			) : NSLocalizedString(
				"photos",
				comment: ""
			)
			let countLabel = UILabel()
			countLabel.text = "\(selectedImages.count) \(photoText)"
			countLabel.font = .systemFont(ofSize: 15, weight: .medium)
			countLabel.textColor = .secondaryLabel
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: countLabel)
		}
		else {
			navigationItem.rightBarButtonItem = nil
		}

		UIView.animate(withDuration: 0.2) {
			self.clearButton.isHidden = !hasImages
			self.buttonStackView.layoutIfNeeded()
		}
	}

	@objc private func openGallery() {
		var configuration = PHPickerConfiguration()
		configuration.selectionLimit = 0
		configuration.filter = .images

		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		present(picker, animated: true)
	}

	@objc private func clearAll() {
		UIView.animate(withDuration: 0.3, animations: {
			self.collectionView?.alpha = 0
		}) { _ in
			self.selectedImages.removeAll()
			self.collectionView?.reloadData()
			self.collectionView?.alpha = 1
			self.updateUI()
		}
	}
}

extension GalleryViewController: PHPickerViewControllerDelegate {
	func picker(
		_ picker: PHPickerViewController,
		didFinishPicking results: [PHPickerResult]
	) {
		picker.dismiss(animated: true)

		let lock = NSLock()
		var loadedImages: [UIImage] = []
		let group = DispatchGroup()

		let maxThumbnailSize: CGFloat = 512

		for result in results {
			group.enter()
			result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
				if let image = object as? UIImage {
					let thumbnail = image.downsized(toFit: maxThumbnailSize)
					lock.lock()
					loadedImages.append(thumbnail)
					lock.unlock()
				}
				group.leave()
			}
		}

		group.notify(queue: .main) { [weak self] in
			guard let self
			else {
				return
			}

			self.selectedImages.append(contentsOf: loadedImages)

			UIView.transition(
				with: self.view,
				duration: 0.3,
				options: .transitionCrossDissolve,
				animations: {
					self.collectionView?.reloadData()
					self.updateUI()
				}
			)
		}
	}
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		selectedImages.count
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: "ImageCell",
			for: indexPath
		) as? ImageCell
		else {
			return UICollectionViewCell()
		}
		cell.configure(with: selectedImages[indexPath.item])
		return cell
	}
}

class ImageCell: UICollectionViewCell {
	private let imageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)

		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 8
		imageView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(imageView)

		contentView.layer.shadowColor = UIColor.black.cgColor
		contentView.layer.shadowOpacity = 0.1
		contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
		contentView.layer.shadowRadius = 4
		contentView.layer.masksToBounds = false

		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with image: UIImage) {
		imageView.image = image
		DevRev.markSensitiveViews([imageView])
	}
}
