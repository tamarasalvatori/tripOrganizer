//
//  ViewController.swift
//  TripOrganizer
//
//  Created by Tamara Salvatori on 05/04/22.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let signInConfig = GIDConfiguration.init(clientID: "140455681498-6vufk8o3mbctk5n2rcaf970oacmv29du.apps.googleusercontent.com")

    @IBAction func signIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let givenName = user?.profile?.givenName
                self.performSegue(withIdentifier: "goToList", sender: nil)
                let listVC = ListViewController()
                listVC.name = givenName ?? ""
            }
        }
    }
}
