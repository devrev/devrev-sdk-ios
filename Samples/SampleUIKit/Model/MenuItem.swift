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

	init(
		title: String,
		destination: UIViewController.Type? = nil,
		style: MenuItemStyle = .normal
	) {
		self.title = title
		self.destination = destination
		self.style = style
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
