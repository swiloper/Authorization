//
//  LogoutViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit
import Firebase

class LogoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
            present(ErrorAlert.createController(message: signOutError.localizedDescription), animated: true)
        }
        performSegue(withIdentifier: "unwindToWelcomeControllerLogoutController", sender: self)
    }
}
