//
//  DetailsViewController.swift
//  TripOrganizer
//
//  Created by Tamara Salvatori on 11/04/22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var details: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = details
    }
    
    @IBAction func deleteTask() {
//        let newCount = count - 1
//        UserDefaults().setValue(newCount, forKey: "count")
//        UserDefaults().setValue(nil, forKey: "details_\(currentPosition)")
    }
}
