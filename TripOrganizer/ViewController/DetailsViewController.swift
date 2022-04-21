
import UIKit

class DetailsViewController: UIViewController {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var details = [String]()
    var place : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.details = UserDefaults.standard.stringArray(forKey: "details") ?? []
                    
        title = "Roteiro \(place)"
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
                        var currentDetails = UserDefaults.standard.stringArray(forKey: "details") ?? []
                        currentDetails.append(text)
                        UserDefaults.standard.setValue(currentDetails, forKey: "details")
                        self?.details.append(text)
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
