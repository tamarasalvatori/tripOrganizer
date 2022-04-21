
import UIKit

struct Trip: Codable {
    var name: String
    var details: [String]
}

class ListViewController: UIViewController {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    var trips: [Trip] = []
    var name: String?
    var tripSelected: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.object(forKey: "trips") as? Data,
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            self.trips = trips
        }
        
        let givenName = name ?? ""
        
        title = "Trip Organizer de \(givenName)"
        view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Nova Viagem", message: "Adicione um novo destino", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Novo destino..."
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        if let `self` = self {
                            var currentTrips = self.getTripData()
                            currentTrips.append(.init(name: text, details: []))
                            self.saveTripData(currentTrips)
                            self.trips = currentTrips
                            self.table.reloadData()
                        }
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
}
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.trips[indexPath.row]
        tripSelected = item
        self.performSegue(withIdentifier: "goToDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = trips[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let vc = segue.destination as? DetailsViewController
            vc?.place = tripSelected
            vc?.delegate = self
        }
    }
    
    private func getTripData() -> [Trip] {
        guard let data = UserDefaults.standard.object(forKey: "trips") as? Data,
              let currentTrips = try? JSONDecoder().decode([Trip].self, from: data) else { return [] }
        
        return currentTrips
    }
    
    private func saveTripData(_ currentTrips: [Trip]) {
        let encoded = try! JSONEncoder().encode(currentTrips)
        UserDefaults.standard.set(encoded, forKey: "trips")
    }
}

extension ListViewController: DetailsDelegate {
    func update(_ details: [String], from place: Trip) {
        if let data = UserDefaults.standard.object(forKey: "trips") as? Data,
           var currentTrips = try? JSONDecoder().decode([Trip].self, from: data) {
            for (index, value) in currentTrips.enumerated() {
                if value.name == place.name {
                    currentTrips[index] = .init(name: value.name, details: details)
                }
            }
            
            let encoded = try! JSONEncoder().encode(currentTrips)
            UserDefaults.standard.set(encoded, forKey: "trips")
            self.trips = currentTrips
        }
    }
}
