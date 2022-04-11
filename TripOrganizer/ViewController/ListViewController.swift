//
//  ListViewController.swift
//  TripOrganizer
//
//  Created by Tamara Salvatori on 11/04/22.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var trips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Viagens"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        updateTrips()
    }
    
    func updateTrips() {
        trips.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if let trip = UserDefaults().value(forKey: "trip_\(x+1)") as? String {
                trips.append(trip)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "Nova viagem"
        
        vc.update = {
            DispatchQueue.main.async {
                self.updateTrips()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsViewController
        vc.title = "Nova viagem"
        vc.details = trips[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = trips[indexPath.row]
        return cell
    }
}
