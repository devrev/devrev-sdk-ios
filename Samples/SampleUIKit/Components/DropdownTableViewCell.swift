import Foundation
import UIKit

class DropdownTableViewCell: UITableViewCell {
	private let titleLabel = UILabel()
	private let selectionButton = UIButton(type: .system)
	private var options: [String] = []
	private var selectedOption = ""
	private var onSelectionChanged: ((String) -> Void)?

	override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier: String?
	) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}

	func configure(
		title: String,
		options: [String],
		selectedOption: String,
		onSelectionChanged: @escaping (String) -> Void
	) {
		titleLabel.text = title
		self.options = options
		self.selectedOption = selectedOption
		self.onSelectionChanged = onSelectionChanged
		updateSelectionButton(with: selectedOption)
		refreshMenu()
		selectionButton.showsMenuAsPrimaryAction = true
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		selectionButton.setTitle(nil, for: .normal)
		selectionButton.menu = nil
		options = []
		selectedOption = ""
		onSelectionChanged = nil
	}
}

private extension DropdownTableViewCell {
	func setupViews() {
		selectionStyle = .none

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

		selectionButton.translatesAutoresizingMaskIntoConstraints = false
		selectionButton.titleLabel?.font = .preferredFont(forTextStyle: .body)
		selectionButton.setTitleColor(.secondaryLabel, for: .normal)
		selectionButton.contentHorizontalAlignment = .trailing

		contentView.addSubview(titleLabel)
		contentView.addSubview(selectionButton)

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(
				equalTo: contentView.layoutMarginsGuide.leadingAnchor
			),
			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectionButton.leadingAnchor.constraint(
				greaterThanOrEqualTo: titleLabel.trailingAnchor,
				constant: 8
			),
			selectionButton.trailingAnchor.constraint(
				equalTo: contentView.layoutMarginsGuide.trailingAnchor
			),
			selectionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectionButton.topAnchor.constraint(
				greaterThanOrEqualTo: contentView.topAnchor,
				constant: 11
			),
			selectionButton.bottomAnchor.constraint(
				lessThanOrEqualTo: contentView.bottomAnchor,
				constant: -11
			),
		])
	}

	func updateSelectionButton(with selectedOption: String) {
		var configuration = UIButton.Configuration.plain()
		configuration.title = selectedOption
		configuration.image = UIImage(systemName: "chevron.up.chevron.down")
		configuration.imagePlacement = .trailing
		configuration.imagePadding = 4
		configuration.baseForegroundColor = .secondaryLabel
		selectionButton.configuration = configuration
	}

	func refreshMenu() {
		let actions = options.map { option in
			UIAction(
				title: option,
				state: option == selectedOption ? .on : .off
			) { [weak self] _ in
				guard let self else {
					return
				}

				self.selectedOption = option
				self.updateSelectionButton(with: option)
				self.refreshMenu()
				self.onSelectionChanged?(option)
			}
		}

		selectionButton.menu = UIMenu(
			title: "",
			children: actions
		)
	}
}
