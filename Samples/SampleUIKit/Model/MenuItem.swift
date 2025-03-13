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
	let destination: UITableViewController.Type?
	let style: MenuItemStyle

	init(
		title: String,
		destination: UITableViewController.Type? = nil,
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
