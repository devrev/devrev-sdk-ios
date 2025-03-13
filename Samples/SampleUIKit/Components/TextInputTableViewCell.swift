import Foundation
import UIKit

class TextInputTableViewCell: UITableViewCell {
	@IBOutlet private weak var textField: UITextField!

	var text: String? {
		textField?.text
	}

	func configure(with text: String) {
		textField?.placeholder = text
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		textField?.text = nil
		textField?.placeholder = nil
	}
}
