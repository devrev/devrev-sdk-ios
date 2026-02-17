import UIKit

class EmptyStateView: UIView {
	init(
		systemImageName: String,
		title: String,
		message: String
	) {
		super.init(frame: .zero)

		translatesAutoresizingMaskIntoConstraints = false

		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 16
		stackView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(stackView)

		let iconConfig = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
		let iconImageView = UIImageView()
		iconImageView.image = UIImage(systemName: systemImageName, withConfiguration: iconConfig)
		iconImageView.tintColor = .systemGray3
		iconImageView.contentMode = .scaleAspectFit
		stackView.addArrangedSubview(iconImageView)

		let titleLabel = UILabel()
		titleLabel.text = title
		titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
		titleLabel.textColor = .systemGray
		titleLabel.textAlignment = .center
		stackView.addArrangedSubview(titleLabel)

		let messageLabel = UILabel()
		messageLabel.text = message
		messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
		messageLabel.textColor = .systemGray2
		messageLabel.textAlignment = .center
		messageLabel.numberOfLines = 0
		stackView.addArrangedSubview(messageLabel)

		NSLayoutConstraint.activate(
			[
				stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
				stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
				stackView.leadingAnchor.constraint(
					greaterThanOrEqualTo: leadingAnchor,
					constant: 40
				),
				stackView.trailingAnchor.constraint(
					lessThanOrEqualTo: trailingAnchor,
					constant: -40
				),
			]
		)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
