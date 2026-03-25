import Foundation
import UIKit
import AVKit
import Lottie

class HeavyUIViewController: UIViewController {
	private var isMuted = true
	private var player: AVPlayer?

	// MARK: - Views

	private let introContainerView = UIView()
	private let mainContainerView = UIView()
	private let topBarView = UIView()
	private let videoContainerView = UIView()
	private let muteButton = UIButton(type: .system)

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .black
		setupIntroView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		setupMainContent()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		player?.pause()
	}
}

// MARK: - Intro

private extension HeavyUIViewController {
	func setupIntroView() {
		introContainerView.backgroundColor = .black
		introContainerView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(introContainerView)

		let animationView = createLocalLottieView(
			name: "be_bold_animation",
			loopMode: .playOnce
		)
		animationView.translatesAutoresizingMaskIntoConstraints = false
		introContainerView.addSubview(animationView)

		let nextButton = UIButton(type: .system)
		nextButton.setTitle(
			NSLocalizedString("Next →", comment: ""),
			for: .normal
		)

		nextButton.setTitleColor(.white, for: .normal)
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.addTarget(
			self,
			action: #selector(showMainContent),
			for: .touchUpInside
		)

		introContainerView.addSubview(nextButton)

		introContainerView.pinEdges(to: view)

		NSLayoutConstraint.activate(
			[
				animationView.centerXAnchor.constraint(
					equalTo: introContainerView.centerXAnchor
				),
				animationView.centerYAnchor.constraint(
					equalTo: introContainerView.centerYAnchor
				),
				animationView.leadingAnchor.constraint(
					equalTo: introContainerView.leadingAnchor
				),
				animationView.trailingAnchor.constraint(
					equalTo: introContainerView.trailingAnchor
				),
				animationView.heightAnchor.constraint(
					equalTo: animationView.widthAnchor
				),

				nextButton.centerXAnchor.constraint(
					equalTo: introContainerView.centerXAnchor
				),
				nextButton.topAnchor.constraint(
					equalTo: animationView.bottomAnchor,
					constant: 16
				),
			]
		)
	}

	@objc func showMainContent() {
		introContainerView.isHidden = true
		mainContainerView.isHidden = false
		view.backgroundColor = .systemBackground
		setupVideoPlayer()
	}
}

// MARK: - Main Content

private extension HeavyUIViewController {
	func setupMainContent() {
		mainContainerView.translatesAutoresizingMaskIntoConstraints = false
		mainContainerView.isHidden = true
		view.addSubview(mainContainerView)

		mainContainerView.pinEdges(to: view)

		setupTopBar()
		setupScrollView()
	}

	func setupTopBar() {
		topBarView.translatesAutoresizingMaskIntoConstraints = false
		mainContainerView.addSubview(topBarView)

		let logoView = createDevRevLogo()
		logoView.translatesAutoresizingMaskIntoConstraints = false
		topBarView.addSubview(logoView)

		let sayHiView = createLocalLottieView(
			name: "say_hi",
			loopMode: .loop
		)
		sayHiView.translatesAutoresizingMaskIntoConstraints = false
		topBarView.addSubview(sayHiView)

		NSLayoutConstraint.activate(
			[
				topBarView.topAnchor.constraint(
					equalTo: mainContainerView.topAnchor,
					constant: 60
				),
				topBarView.leadingAnchor.constraint(
					equalTo: mainContainerView.leadingAnchor,
					constant: 10
				),
				topBarView.trailingAnchor.constraint(
					equalTo: mainContainerView.trailingAnchor,
					constant: -10
				),
				topBarView.heightAnchor.constraint(
					equalToConstant: 50
				),

				sayHiView.trailingAnchor.constraint(
					equalTo: topBarView.trailingAnchor
				),
				sayHiView.centerYAnchor.constraint(
					equalTo: topBarView.centerYAnchor
				),
				sayHiView.widthAnchor.constraint(
					equalToConstant: 50
				),
				sayHiView.heightAnchor.constraint(
					equalToConstant: 50
				),

				logoView.trailingAnchor.constraint(
					equalTo: sayHiView.leadingAnchor,
					constant: -8
				),
				logoView.centerYAnchor.constraint(
					equalTo: topBarView.centerYAnchor
				),
			]
		)
	}

	func createDevRevLogo() -> UIView {
		let container = UIView()

		let logoImageView = UIImageView(image: UIImage(named: "devrev_logo"))
		logoImageView.contentMode = .scaleAspectFit
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(logoImageView)

		let label = UILabel()
		label.text = "DevRev"
		label.font = .preferredFont(forTextStyle: .subheadline).bold()
		label.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(label)

		container.backgroundColor = UIColor.black.withAlphaComponent(0.1)
		container.layer.cornerRadius = 20

		NSLayoutConstraint.activate(
			[
				logoImageView.leadingAnchor.constraint(
					equalTo: container.leadingAnchor,
					constant: 10
				),
				logoImageView.centerYAnchor.constraint(
					equalTo: container.centerYAnchor
				),
				logoImageView.widthAnchor.constraint(
					equalToConstant: 20
				),
				logoImageView.heightAnchor.constraint(
					equalToConstant: 20
				),

				label.leadingAnchor.constraint(
					equalTo: logoImageView.trailingAnchor,
					constant: 5
				),
				label.trailingAnchor.constraint(
					equalTo: container.trailingAnchor,
					constant: -10
				),
				label.centerYAnchor.constraint(
					equalTo: container.centerYAnchor
				),

				container.heightAnchor.constraint(
					equalToConstant: 44
				),
			]
		)

		return container
	}

	func setupScrollView() {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		mainContainerView.addSubview(scrollView)

		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(contentView)

		videoContainerView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(videoContainerView)

		let animationsSection = createAnimationsSection()
		animationsSection.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(animationsSection)

		let imagesSection = createImagesSection()
		imagesSection.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(imagesSection)

		contentView.pinEdges(to: scrollView)

		NSLayoutConstraint.activate(
			[
				scrollView.topAnchor.constraint(
					equalTo: topBarView.bottomAnchor
				),
				scrollView.leadingAnchor.constraint(
					equalTo: mainContainerView.leadingAnchor
				),
				scrollView.trailingAnchor.constraint(
					equalTo: mainContainerView.trailingAnchor
				),
				scrollView.bottomAnchor.constraint(
					equalTo: mainContainerView.bottomAnchor
				),

				contentView.widthAnchor.constraint(
					equalTo: scrollView.widthAnchor
				),

				videoContainerView.topAnchor.constraint(
					equalTo: contentView.topAnchor
				),
				videoContainerView.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor
				),
				videoContainerView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor
				),
				videoContainerView.heightAnchor.constraint(
					equalToConstant: 226
				),

				animationsSection.topAnchor.constraint(
					equalTo: videoContainerView.bottomAnchor,
					constant: 10
				),
				animationsSection.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor
				),
				animationsSection.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor
				),

				imagesSection.topAnchor.constraint(
					equalTo: animationsSection.bottomAnchor,
					constant: 10
				),
				imagesSection.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor
				),
				imagesSection.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor
				),
				imagesSection.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor,
					constant: -16
				),
			]
		)
	}
}

// MARK: - Video Player

private extension HeavyUIViewController {
	func setupVideoPlayer() {
		guard
			let url = Bundle.main.url(
				forResource: "MeetComputer",
				withExtension: "mp4"
			)
		else {
			let label = UILabel()
			label.text = NSLocalizedString("Video not found", comment: "")
			label.textAlignment = .center
			label.translatesAutoresizingMaskIntoConstraints = false
			videoContainerView.addSubview(label)

			NSLayoutConstraint.activate(
				[
					label.centerXAnchor.constraint(
						equalTo: videoContainerView.centerXAnchor
					),
					label.centerYAnchor.constraint(
						equalTo: videoContainerView.centerYAnchor
					),
				]
			)
			return
		}

		let avPlayer = AVPlayer(url: url)
		avPlayer.isMuted = true
		player = avPlayer

		let playerVC = AVPlayerViewController()
		playerVC.player = avPlayer
		playerVC.showsPlaybackControls = false
		playerVC.view.translatesAutoresizingMaskIntoConstraints = false

		addChild(playerVC)
		videoContainerView.addSubview(playerVC.view)
		playerVC.didMove(toParent: self)

		playerVC.view.pinEdges(to: videoContainerView)

		setupMuteButton()

		NotificationCenter.default.addObserver(
			forName: .AVPlayerItemDidPlayToEndTime,
			object: avPlayer.currentItem,
			queue: .main
		) { [weak avPlayer] _ in
			avPlayer?.seek(to: .zero)
			avPlayer?.play()
		}

		avPlayer.play()
	}

	func setupMuteButton() {
		updateMuteButtonImage()
		muteButton.tintColor = .white
		muteButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		muteButton.layer.cornerRadius = 20
		muteButton.clipsToBounds = true
		muteButton.translatesAutoresizingMaskIntoConstraints = false
		muteButton.addTarget(
			self,
			action: #selector(toggleMute),
			for: .touchUpInside
		)

		videoContainerView.addSubview(muteButton)

		NSLayoutConstraint.activate(
			[
				muteButton.topAnchor.constraint(
					equalTo: videoContainerView.topAnchor,
					constant: 16
				),
				muteButton.trailingAnchor.constraint(
					equalTo: videoContainerView.trailingAnchor,
					constant: -16
				),
				muteButton.widthAnchor.constraint(
					equalToConstant: 40
				),
				muteButton.heightAnchor.constraint(
					equalToConstant: 40
				),
			]
		)
	}

	@objc func toggleMute() {
		isMuted.toggle()
		player?.isMuted = isMuted
		updateMuteButtonImage()
	}

	func updateMuteButtonImage() {
		let imageName = isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill"
		muteButton.setImage(
			UIImage(systemName: imageName),
			for: .normal
		)
	}
}

// MARK: - Content Sections

private extension HeavyUIViewController {
	func createHorizontalScrollSection(
		title: String,
		height: CGFloat,
		populate: (UIView) -> Void
	) -> UIView {
		let container = UIView()

		let titleLabel = UILabel()
		titleLabel.text = NSLocalizedString(title, comment: "")
		titleLabel.font = .preferredFont(forTextStyle: .title1).bold()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(titleLabel)

		let scrollView = UIScrollView()
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(scrollView)

		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(contentView)

		contentView.pinEdges(to: scrollView)

		NSLayoutConstraint.activate(
			[
				titleLabel.topAnchor.constraint(
					equalTo: container.topAnchor,
					constant: 16
				),
				titleLabel.leadingAnchor.constraint(
					equalTo: container.leadingAnchor,
					constant: 16
				),

				scrollView.topAnchor.constraint(
					equalTo: titleLabel.bottomAnchor,
					constant: 8
				),
				scrollView.leadingAnchor.constraint(
					equalTo: container.leadingAnchor
				),
				scrollView.trailingAnchor.constraint(
					equalTo: container.trailingAnchor
				),
				scrollView.heightAnchor.constraint(
					equalToConstant: height
				),
				scrollView.bottomAnchor.constraint(
					equalTo: container.bottomAnchor
				),

				contentView.heightAnchor.constraint(
					equalTo: scrollView.heightAnchor
				),
			]
		)

		populate(contentView)

		return container
	}

	func createAnimationsSection() -> UIView {
		createHorizontalScrollSection(
			title: "Animations:",
			height: 320
		) { contentView in
			populateAnimationsContent(in: contentView)
		}
	}

	func createImagesSection() -> UIView {
		createHorizontalScrollSection(
			title: "Images:",
			height: 320
		) { contentView in
			populateImagesContent(in: contentView)
		}
	}

	func populateAnimationsContent(in contentView: UIView) {
		var previousView: UIView?

		for column in HeavyUIData.lottieAnimations {
			let columnView = createAnimationColumn(
				names: column,
				in: contentView,
				after: previousView
			)
			previousView = columnView
		}

		let bigAnimationView = createAnimationItemView(
			name: "lottie_empty",
			width: 300,
			height: 320
		)
		bigAnimationView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(bigAnimationView)

		let bigLeadingAnchor = previousView?.trailingAnchor ?? contentView.leadingAnchor

		NSLayoutConstraint.activate(
			[
				bigAnimationView.topAnchor.constraint(
					equalTo: contentView.topAnchor
				),
				bigAnimationView.leadingAnchor.constraint(
					equalTo: bigLeadingAnchor,
					constant: 20
				),
				bigAnimationView.widthAnchor.constraint(
					equalToConstant: 300
				),
				bigAnimationView.heightAnchor.constraint(
					equalToConstant: 320
				),
				bigAnimationView.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -16
				),
			]
		)
	}

	func createAnimationColumn(
		names: [String],
		in contentView: UIView,
		after previousView: UIView?
	) -> UIScrollView {
		let columnScrollView = UIScrollView()
		columnScrollView.showsVerticalScrollIndicator = false
		columnScrollView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(columnScrollView)

		let columnContent = UIStackView()
		columnContent.axis = .vertical
		columnContent.spacing = 5
		columnContent.translatesAutoresizingMaskIntoConstraints = false
		columnScrollView.addSubview(columnContent)

		for name in names {
			let itemView = createAnimationItemView(
				name: name,
				width: 150,
				height: 150
			)
			columnContent.addArrangedSubview(itemView)
		}

		let leadingAnchor = previousView?.trailingAnchor ?? contentView.leadingAnchor
		let leadingConstant: CGFloat = previousView == nil ? 16 : 20

		columnContent.pinEdges(to: columnScrollView)

		NSLayoutConstraint.activate(
			[
				columnScrollView.topAnchor.constraint(
					equalTo: contentView.topAnchor
				),
				columnScrollView.leadingAnchor.constraint(
					equalTo: leadingAnchor,
					constant: leadingConstant
				),
				columnScrollView.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor
				),
				columnScrollView.widthAnchor.constraint(
					equalToConstant: 150
				),

				columnContent.widthAnchor.constraint(
					equalTo: columnScrollView.widthAnchor
				),
			]
		)

		return columnScrollView
	}

	func createAnimationItemView(
		name: String,
		width: CGFloat,
		height: CGFloat
	) -> UIView {
		let container = UIView()
		container.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
		container.layer.cornerRadius = 30
		container.clipsToBounds = true
		container.translatesAutoresizingMaskIntoConstraints = false

		let lottieView = createLocalLottieView(name: name, loopMode: .loop)
		lottieView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(lottieView)

		lottieView.pinEdges(to: container)

		NSLayoutConstraint.activate(
			[
				container.widthAnchor.constraint(equalToConstant: width),
				container.heightAnchor.constraint(equalToConstant: height),
			]
		)

		return container
	}

	func populateImagesContent(in contentView: UIView) {
		var previousView: UIView?

		for imageName in HeavyUIData.images {
			let imageContainer = createLocalImageView(
				name: imageName,
				width: 300,
				height: 300
			)
			imageContainer.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(imageContainer)

			let leadingAnchor = previousView?.trailingAnchor ?? contentView.leadingAnchor
			let leadingConstant: CGFloat = previousView == nil ? 16 : 20

			NSLayoutConstraint.activate(
				[
					imageContainer.topAnchor.constraint(
						equalTo: contentView.topAnchor
					),
					imageContainer.leadingAnchor.constraint(
						equalTo: leadingAnchor,
						constant: leadingConstant
					),
					imageContainer.widthAnchor.constraint(
						equalToConstant: 300
					),
					imageContainer.heightAnchor.constraint(
						equalToConstant: 300
					),
				]
			)

			previousView = imageContainer
		}

		if let lastView = previousView {
			lastView.trailingAnchor.constraint(
				equalTo: contentView.trailingAnchor,
				constant: -16
			).isActive = true
		}
	}

	func createLocalImageView(
		name: String,
		width: CGFloat,
		height: CGFloat
	) -> UIView {
		let container = UIView()
		container.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
		container.layer.cornerRadius = 30
		container.clipsToBounds = true

		let image: UIImage? = {
			guard let url = Bundle.main.url(forResource: name, withExtension: nil) else { return nil }
			return UIImage(contentsOfFile: url.path)
		}()
		let imageView = UIImageView(image: image)
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		container.addSubview(imageView)

		imageView.pinEdges(to: container)

		return container
	}
}

// MARK: - Lottie

private extension HeavyUIViewController {
	func createLocalLottieView(
		name: String,
		loopMode: LottieLoopMode
	) -> LottieAnimationView {
		let animation = LottieAnimation.named(name)
		let animationView = LottieAnimationView(animation: animation)
		animationView.contentMode = .scaleAspectFit
		animationView.loopMode = loopMode
		animationView.backgroundBehavior = .pauseAndRestore
		animationView.play()

		return animationView
	}
}

// MARK: - UIView Helpers

private extension UIView {
	func pinEdges(to other: UIView) {
		NSLayoutConstraint.activate(
			[
				topAnchor.constraint(equalTo: other.topAnchor),
				leadingAnchor.constraint(equalTo: other.leadingAnchor),
				trailingAnchor.constraint(equalTo: other.trailingAnchor),
				bottomAnchor.constraint(equalTo: other.bottomAnchor),
			]
		)
	}
}

// MARK: - UIFont Extension

private extension UIFont {
	func bold() -> UIFont {
		guard
			let descriptor = fontDescriptor.withSymbolicTraits(.traitBold)
		else {
			return self
		}

		return UIFont(descriptor: descriptor, size: pointSize)
	}
}
