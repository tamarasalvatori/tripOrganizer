
import UIKit

protocol DetailsDelegate: AnyObject {
    func update(_ details: [String], from place: Trip)
}

class DetailsViewController: UIViewController {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var details: [String] = []

    var place : Trip?

    weak var delegate: DetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.details = place?.details ?? []

        if let placeName = place?.name {
            title = "Roteiro \(placeName)"
        }
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Novo Roteiro", message: "Adicione um novo roteiro", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Novo roteiro..."}
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        self?.details.append(text)

                        if let details = self?.details, let place = self?.place {
                            self?.delegate?.update(details, from: place)
                        }

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
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                              for: indexPath)
        cell.textLabel?.text = details[indexPath.row]
        return cell
    }
}
