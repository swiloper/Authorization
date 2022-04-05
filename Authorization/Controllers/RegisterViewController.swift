//
//  RegisterViewController.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameTextField: AuthorizationTextField!
    @IBOutlet weak var emailTextField: AuthorizationTextField!
    @IBOutlet weak var passwordTextField: AuthorizationTextField!
    @IBOutlet weak var nameDescriptionLabel: UILabel!
    @IBOutlet weak var emailDescriptionLabel: UILabel!
    @IBOutlet weak var passwordDescriptionLabel: UILabel!
    
    lazy var passwordDescriptionLabelMaxY = passwordDescriptionLabel.frame.maxY
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.addClearButton()
        emailTextField.addClearButton()
        passwordTextField.addShowSecureTextButton()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                self.view.window?.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboard = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = view.convert(keyboard.cgRectValue, from: nil)
            if passwordDescriptionLabelMaxY > keyboardFrame.origin.y && passwordTextField.isEditing {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.window?.frame.origin.y = -(self.passwordDescriptionLabelMaxY + 8 - keyboardFrame.origin.y)
                })
            }
        }
    }
    
    func checkTextFieldInput(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        if textField.tag == 2 {
            let checkResult = text.checkName()
            if checkResult.isEmpty {
                textField.validAppearance()
                nameDescriptionLabel.defaultText()
            } else {
                textField.invalidAppearance(descriptionLabel: nameDescriptionLabel, text: checkResult)
            }
        } else if textField.tag == 3 {
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
    
    @IBAction func registerAction(_ sender: UIButton) {
        checkTextFieldInput(nameTextField)
        checkTextFieldInput(emailTextField)
        checkTextFieldInput(passwordTextField)
        if nameTextField.isValid && emailTextField.isValid && passwordTextField.isValid {
            registerUser()
        }
    }
    
    func registerUser() {
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                } else {
                    if let result = result {
                        let ref = Database.database().reference().child("users")
                        ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                        let logoutController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogoutViewController")
                        logoutController.modalPresentationStyle = .fullScreen
                        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                            if let error = error {
                                self.present(ErrorAlert.createController(message: error.localizedDescription), animated: true)
                            } else {
                                self.present(logoutController, animated: true)
                            }
                        })
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 2:
            textField.defaultAppearance()
            nameDescriptionLabel.defaultText()
        case 3:
            textField.defaultAppearance()
            emailDescriptionLabel.defaultText()
        case 4:
            textField.defaultAppearance()
            passwordDescriptionLabel.defaultText()
        default:
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextFieldInput(textField)
        if textField.tag == 4 {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.window?.frame.origin.y = 0
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 2:
            emailTextField.becomeFirstResponder()
        case 3:
            passwordTextField.becomeFirstResponder()
        case 4:
            textField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}
