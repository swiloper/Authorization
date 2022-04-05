//
//  WelcomeViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit
import Firebase
import FacebookLogin
import GoogleSignIn

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            presentLogoutController()
        }
    }
    
    private func presentLogoutController() {
        let logoutController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoutViewController")
        logoutController.modalPresentationStyle = .fullScreen
        present(logoutController, animated: true)
    }
    
    // MARK: IBActions
    
    @IBAction func loginWithGoogleAction(_ sender: UIButton) {
        let signInConfig = GIDConfiguration.init(clientID: "248076529813-7derqa8fggrjthhkfidasjnj5oa1n18f.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
            } else {
                guard let user = user else { return }
                guard let idToken = user.authentication.idToken else { return }
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                    } else {
                        self.presentLogoutController()
                    }
                }
            }
        }
    }
    
    @IBAction func loginWithFacebookAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if let error = error {
                self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
            } else {
                if let result = result {
                    if result.isCancelled {
                        return
                    }
                }
                
                guard let currentAccessToken = AccessToken.current else { return }
                
                GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: currentAccessToken.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET")).start { (nil, result, error) in
                    if let error = error {
                        self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                    } else {
                        let credential = FacebookAuthProvider.credential(withAccessToken: currentAccessToken.tokenString)
                        Auth.auth().signIn(with: credential) { result, error in
                            if let error = error {
                                self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                            } else {
                                self.presentLogoutController()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func unwindSegue(with: UIStoryboardSegue) {}
}
