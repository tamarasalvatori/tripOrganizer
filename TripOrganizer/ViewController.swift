//
//  ViewController.swift
//  TripOrganizer
//
//  Created by Tamara Salvatori on 05/04/22.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let signInConfig = GIDConfiguration.init(clientID: "140455681498-6vufk8o3mbctk5n2rcaf970oacmv29du.apps.googleusercontent.com")

    @IBAction func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
        }
    }
    
//    @IBAction func signOut(sender: Any) {
//      GIDSignIn.sharedInstance.signOut()
//    }

}
