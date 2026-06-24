import Foundation
import UIKit

class SegmentTableViewCell: UITableViewCell {
	private let titleLabel = UILabel()
	private let segmentedControl = UISegmentedControl()
	private var onSelectionChanged: ((Int, String) -> Void)?

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
		segments: [String],
		selectedIndex: Int,
		onSelectionChanged: @escaping (Int, String) -> Void
	) {
		titleLabel.text = title
		self.onSelectionChanged = onSelectionChanged

		segmentedControl.removeAllSegments()
		for (index, segment) in segments.enumerated() {
			segmentedControl.insertSegment(
				withTitle: segment,
				at: index,
				animated: false
			)
		}

		let clampedIndex = min(max(selectedIndex, 0), segments.count - 1)
		segmentedControl.selectedSegmentIndex = clampedIndex
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		titleLabel.text = nil
		segmentedControl.removeAllSegments()
		segmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
		onSelectionChanged = nil
	}
}

private extension SegmentTableViewCell {
	func setupViews() {
		selectionStyle = .none

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = .preferredFont(forTextStyle: .body)
		titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.addTarget(
			self,
			action: #selector(segmentValueChanged),
			for: .valueChanged
		)

		contentView.addSubview(titleLabel)
		contentView.addSubview(segmentedControl)

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(
				equalTo: contentView.layoutMarginsGuide.leadingAnchor
			),
			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			segmentedControl.leadingAnchor.constraint(
				greaterThanOrEqualTo: titleLabel.trailingAnchor,
				constant: 8
			),
			segmentedControl.trailingAnchor.constraint(
				equalTo: contentView.layoutMarginsGuide.trailingAnchor
			),
			segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			segmentedControl.topAnchor.constraint(
				greaterThanOrEqualTo: contentView.topAnchor,
				constant: 11
			),
			segmentedControl.bottomAnchor.constraint(
				lessThanOrEqualTo: contentView.bottomAnchor,
				constant: -11
			),
		])
	}

	@objc func segmentValueChanged() {
		let selectedIndex = segmentedControl.selectedSegmentIndex
		guard
			selectedIndex != UISegmentedControl.noSegment,
			let selectedTitle = segmentedControl.titleForSegment(at: selectedIndex)
		else {
			return
		}

		onSelectionChanged?(selectedIndex, selectedTitle)
	}
}
