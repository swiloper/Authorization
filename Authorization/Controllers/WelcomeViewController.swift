//
//  ViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            let logoutController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoutViewController")
            logoutController.modalPresentationStyle = .fullScreen
            present(logoutController, animated: true)
        }
    }
    
    @IBAction func unwindSegue(with: UIStoryboardSegue) {}
}

