//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

    private var controller: WeatherController!

    static func create(controller: WeatherController) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateInitialViewController() as! WeatherViewController

        viewController.controller = controller
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setup()
    }

    private func setup() {
        title = "Weather Code Test"
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
}

extension WeatherViewController: WeatherView {
    func showEntries() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}

extension WeatherViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell

        let entry = controller.entries[indexPath.row]
        cell.setup(entry)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            controller.removeLocation(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
