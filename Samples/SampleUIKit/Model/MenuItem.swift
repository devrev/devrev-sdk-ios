import Foundation
import UIKit
import DevRevSDK

protocol MenuItem {
    var title: String {get set}
}

struct ActionableMenuItem: MenuItem {
    var title: String
    let destination: UIViewController.Type?
}

struct UserStatusMenuItem: MenuItem {
    var title: String
    var isUserIdentified: Bool
}
