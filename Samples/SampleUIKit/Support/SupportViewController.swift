import UIKit
import DevRevSDK

class SupportViewController: UITableViewController {
    private var isSupportVisible = false
    private var isUserIdentified = false

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = NSLocalizedString("Support", comment: "")
        tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.support)
    }
	
	private var items: [MenuItem] = [
		ActionableMenuItem(title: NSLocalizedString("Support Chat", comment: ""), destination: nil),
		ActionableMenuItem(title: NSLocalizedString("Support View", comment: ""), destination: nil)
	]
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.support, for: indexPath)
		let supportItem = items[indexPath.row]
		cell.textLabel?.text = supportItem.title
		return cell
    }
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			createSupportConversation()
		case 1:
			showSupport()
		default:
			break
		}
	}
	
    private func createSupportConversation()
    {
        Task {
            guard
				await DevRev.isUserIdentified
            else {
                return
            }
    
            await DevRev.createSupportConversation()
        }
    }
    
    @IBAction func showSupport() {
        Task {
            guard
				await DevRev.isUserIdentified
            else {
                return
            }
            
            await DevRev.showSupport(isAnimated: true)
        }
    }
}
