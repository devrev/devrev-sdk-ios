import Foundation
import UIKit

class TextField: UITextField {
	convenience init(frame: CGRect, placeholder: String) {
		self.init(frame: frame)
		self.placeholder = placeholder
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}

	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		borderStyle = .roundedRect
	}
}
