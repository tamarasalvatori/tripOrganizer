//
//  EntryViewController.swift
//  TripOrganizer
//
//  Created by Tamara Salvatori on 11/04/22.
//

import UIKit

class EntryViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //field.delegate
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTrip()
        return true
    }
    
    @IBAction func saveTrip() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(newCount, forKey: "trip_\(newCount)")

        update()
        
        navigationController?.popViewController(animated: true)
    }
}
