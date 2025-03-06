import Foundation
import UIKit

class TextInputTableViewCell: UITableViewCell {
	@IBOutlet weak var textField: UITextField!

	func configure(with text: String) {
		textField?.placeholder = text
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		textField?.text = nil
		textField?.placeholder = nil
	}
}
