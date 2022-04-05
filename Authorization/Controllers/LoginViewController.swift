//
//  LoginViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: AuthorizationTextField!
    @IBOutlet weak var passwordTextField: AuthorizationTextField!
    @IBOutlet weak var emailDescriptionLabel: UILabel!
    @IBOutlet weak var passwordDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addClearButton()
        passwordTextField.addShowSecureTextButton()
    }
    
    func checkTextFieldInput(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if textField.tag == 0 {
            let checkResult = text.checkEmail()
            if checkResult.isEmpty {
                textField.validAppearance()
                emailDescriptionLabel.defaultText()
            } else {
                textField.invalidAppearance(descriptionLabel: emailDescriptionLabel, text: checkResult)
            }
        } else {
            let checkResult = text.checkPassword()
            if checkResult.isEmpty {
                textField.validAppearance()
                emailDescriptionLabel.defaultText()
            } else {
                textField.invalidAppearance(descriptionLabel: passwordDescriptionLabel, text: checkResult)
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func loginAction(_ sender: UIButton) {
        checkTextFieldInput(emailTextField)
        checkTextFieldInput(passwordTextField)
        if emailTextField.isValid && passwordTextField.isValid {
            loginUser()
        }
    }
    
    func loginUser() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result {
                    if !result.user.isEmailVerified {
                        self.emailTextField.invalidAppearance(descriptionLabel: self.emailDescriptionLabel, text: "You need to confirm your email.")
                        return
                    }
                }
                if error == nil {
                    let logoutController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoutViewController")
                    logoutController.modalPresentationStyle = .fullScreen
                    self.present(logoutController, animated: true)
                } else {
                    if let error = error {
                        if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                            self.emailTextField.invalidAppearance(descriptionLabel: self.emailDescriptionLabel, text: "The user with such email does not exist.")
                        } else if error.localizedDescription == "The password is invalid or the user does not have a password." {
                            self.passwordTextField.invalidAppearance(descriptionLabel: self.passwordDescriptionLabel, text: "The entered password is not correct.")
                        } else {
                            self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func dismissController(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.defaultAppearance()
            emailDescriptionLabel.defaultText()
        case 1:
            textField.defaultAppearance()
            passwordDescriptionLabel.defaultText()
        default:
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextFieldInput(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            passwordTextField.becomeFirstResponder()
        case 1:
            textField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}
