import Foundation
import UIKit

extension UITableViewCell {
	static func dequeue(
		from tableView: UITableView,
		at indexPath: IndexPath,
		reuseIdentifier: String
	) -> Self {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Self
		else {
			fatalError("Could not dequeue a cell for \(reuseIdentifier)! For nib-backed cells, check if the class name has been set in the nib itself.")
		}

		return cell
	}
}
