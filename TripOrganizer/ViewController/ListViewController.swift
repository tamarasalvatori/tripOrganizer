
import UIKit

class ListViewController: UIViewController, UITableViewDataSource {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var trips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trips = UserDefaults.standard.stringArray(forKey: "trips") ?? []
        title = "Trip Organizer"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Nova Viagem", message: "Adicione um novo destino", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Novo destino..."}
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentTrips = UserDefaults.standard.stringArray(forKey: "trips") ?? []
                        currentTrips.append(text)
                        UserDefaults.standard.setValue(currentTrips, forKey: "trips")
                        self?.trips.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                              for: indexPath)
        cell.textLabel?.text = trips[indexPath.row]
        return cell
    }
    
}
