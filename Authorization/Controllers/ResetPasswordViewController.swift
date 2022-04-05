//
//  ResetPasswordViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 04.04.2022.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: AuthorizationTextField!
    @IBOutlet weak var emailDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.addClearButton()
    }
    
    func checkTextFieldInput(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        let checkResult = text.checkEmail()
        if checkResult.isEmpty {
            textField.validAppearance()
            emailDescriptionLabel.defaultText()
        } else {
            textField.invalidAppearance(descriptionLabel: emailDescriptionLabel, text: checkResult)
        }
    }
    
    @IBAction func ResetPasswordAction(_ sender: UIButton) {
        checkTextFieldInput(emailTextField)
        resetUserPassword()
    }
    
    func resetUserPassword() {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error == nil {
                    self.dismiss(animated: true)
                } else {
                    if let error = error {
                        if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                            self.emailTextField.invalidAppearance(descriptionLabel: self.emailDescriptionLabel, text: "The user with such email does not exist.")
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

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.defaultAppearance()
        emailDescriptionLabel.defaultText()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextFieldInput(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
