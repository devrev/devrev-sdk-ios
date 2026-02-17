import Foundation
import UIKit
import DevRevSDK

protocol MenuItem {
	var title: String { get }
}

enum MenuItemStyle {
	case normal
	case destructive
}

struct ActionableMenuItem: MenuItem {
	let title: String
	let destination: UIViewController.Type?
	let style: MenuItemStyle
	let icon: String?
	let iconColor: UIColor?

	init(
		title: String,
		destination: UIViewController.Type? = nil,
		style: MenuItemStyle = .normal,
		icon: String? = nil,
		iconColor: UIColor? = nil
	) {
		self.title = title
		self.destination = destination
		self.style = style
		self.icon = icon
		self.iconColor = iconColor
	}
}

struct UserStatusMenuItem: MenuItem {
	let title: String
	let status: Bool
}

struct TextFieldMenuItem: MenuItem {
	let title: String
	let placeholder: String
}

struct ManuallyMaskedMenuItem: MenuItem {
	let title: String
}
