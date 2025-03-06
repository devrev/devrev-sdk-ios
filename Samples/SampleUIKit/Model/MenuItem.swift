import Foundation
import UIKit
import DevRevSDK

protocol MenuItem {
	var title: String {get set}
}

struct ActionableMenuItem: MenuItem {
	var title: String
	let destination: UITableViewController.Type?
}

struct UserStatusMenuItem: MenuItem {
	var title: String
	var status: Bool
}

struct TextFieldMenuItem: MenuItem {
	var title: String
	var placeholder: String
}
