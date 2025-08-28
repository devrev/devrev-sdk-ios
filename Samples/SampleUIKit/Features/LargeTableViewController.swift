import Foundation
import UIKit
import DevRevSDK

class TableViewViewController: UITableViewController {
	private var items = (0..<100).map {
		NSLocalizedString("Item #\($0)", comment: "")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Table View"

		tableView.register(
			UITableViewCell.self,
			forCellReuseIdentifier: Constants.CellIdentifier.tableView
		)
	}

	override func tableView(
		_ tableView: UITableView,
		numberOfRowsInSection section: Int
	) -> Int {
		items.count
	}

	override func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath
	) -> UITableViewCell {
		let cell = UITableViewCell.dequeue(
			from: tableView,
			at: indexPath,
			reuseIdentifier: Constants.CellIdentifier.tableView
		)

		cell.textLabel?.text = items[indexPath.row]

		if indexPath.row.isMultiple(of: 2) {
			DevRev.markSensitiveViews([cell])
		}
		else {
			DevRev.unmarkSensitiveViews([cell])
		}

		return cell
	}
}
