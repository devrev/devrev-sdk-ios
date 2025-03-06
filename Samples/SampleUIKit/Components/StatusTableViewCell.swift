import Foundation
import UIKit

class StatusTableViewCell: UITableViewCell {
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var statusImageView: UIImageView!

	func configure(with title: String, status: Bool) {
		titleLabel?.text = title
		statusImageView?.image = UIImage(systemName: status ? "checkmark.circle.fill" : "circle")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel?.text = nil
		statusImageView?.image = nil
	}
}
