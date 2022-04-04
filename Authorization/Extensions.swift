//
//  Extensions.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit

extension UITextField {
    func defaultAppearance(descriptionLabel: UILabel) {
        let loginEmailDescriptionLabelDefaultText = "Enter the email you specified when registering."
        let loginPasswordDescriptionLabelDefaultText = "The password must be the same as the one specified when registering the corresponding user."
        
        let registerNameDescriptionLabelDefaultText = "Please enter your first and last name in English."
        let registerEmailDescriptionLabelDefaultText = "Please enter an email address where a confirmation email will be sent."
        let registerPasswordDescriptionLabelDefaultText = "Password must be at least 6 characters, contain numbers, Latin letters and special characters."
        
        if let lightBlueColor = UIColor.init(named: "lightBlue") {
            layer.borderWidth = 1.0
            layer.borderColor = lightBlueColor.cgColor
            backgroundColor = lightBlueColor
            descriptionLabel.textColor = .darkGray
            
            switch tag {
            case 0:
                descriptionLabel.text = loginEmailDescriptionLabelDefaultText
            case 1:
                descriptionLabel.text = loginPasswordDescriptionLabelDefaultText
            case 2:
                descriptionLabel.text = registerNameDescriptionLabelDefaultText
            case 3:
                descriptionLabel.text = registerEmailDescriptionLabelDefaultText
            case 4:
                descriptionLabel.text = registerPasswordDescriptionLabelDefaultText
            default:
                break
            }
        }
    }
    
    func validAppearance() {
        if let authorizationTextField = self as? AuthorizationTextField, let validGreenColor = UIColor.init(named: "validGreen") {
            authorizationTextField.isValid = true
            layer.borderWidth = 1.0
            layer.borderColor = validGreenColor.cgColor
            backgroundColor = validGreenColor.withAlphaComponent(0.2)
        }
    }
    
    func invalidAppearance(descriptionLabel: UILabel, text: String) {
        if let authorizationTextField = self as? AuthorizationTextField {
            authorizationTextField.isValid = false
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.red.cgColor
            backgroundColor = UIColor.red.withAlphaComponent(0.2)
            descriptionLabel.textColor = .red
            descriptionLabel.text = text
        }
    }
    
    func addClearButton() {
        let button = UIButton()
        let image = UIImage(named: "clear")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleClearAction), for: .touchUpInside)
        rightView = button
        rightViewMode = .whileEditing
    }
    
    @objc func handleClearAction() {
        text = .none
    }
    
    func addShowSecureTextButton() {
        let button = UIButton()
        let closedEyeImage = UIImage(named: "closedEye")
        let eyeImage = UIImage(named: "eye")
        button.setImage(closedEyeImage, for: .normal)
        button.setImage(eyeImage, for: .selected)
        button.addTarget(self, action: #selector(handleShowSecureTextAction(_:)), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
    }
    
    @objc func handleShowSecureTextAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !isSecureTextEntry
    }
}

// MARK: - String extension

extension String {
    func checkName() -> String {
        
        let minNameLength = 4
        let maxNameLength = 50
        
        // Regular expressions
        let allowedCharacters = "[^a-z A-Z]"
        let spacesCount = filter({ $0 == " " }).count
        
        if count < minNameLength {
            return "Your input must be at least 4 characters long."
        }
        if count > maxNameLength {
            return "Your input cannot exceed 50 characters."
        }
        if matches(allowedCharacters) {
            return "Only Latin letters and space are allowed."
        }
        if first == " " {
            return "The first character cannot be a space."
        }
        if last == " " {
            return "The last character cannot be a space."
        }
        if spacesCount != 1 {
            return "One space must be used."
        }
        if !matches("[a-zA-Z]{2,} ") {
            return "The name must be at least 2 characters long."
        }
        if !(matches("^[A-Z][a-z]+ ") && matches(" [A-Z][a-z]+$")) {
            return "The first letters of the first and last name must be capitals."
        }
        
        return String()
    }
    
    func checkEmail() -> String {
        
        let minEmailLength = 6
        let maxEmailLength = 50
        let emailFormat = "^[a-zA-Z0-9.]+@[^.]+[.][^.]+$"
        
        // Regular expressions to check the mail name.
        let onlyNumbers = "^[0-9]+@"
        let lastDot = "[.]@"
        let mailNameNotAllowedCharacters = "[^a-zA-Z0-9.@]"
        
        if count < minEmailLength {
            return "The email must be at least 6 characters long."
        }
        if count > maxEmailLength {
            return "Email cannot be longer than 50 characters."
        }
        
        // Check a few dots in a row
        let dotInRow = "[.]{2,}"
        if matches(dotInRow) {
            return "There can't be multiple dots in a row."
        }
        
        // Check the mail name.
        if matches(mailNameNotAllowedCharacters) {
            return "The mail can only contain Latin letters, numbers and dots."
        }
        if !contains("@") || filter({ $0 == "@" }).count > 1 || !matches(emailFormat) {
            return "Incorrect format."
        }
        if matches(onlyNumbers) {
            return "The mail name can't only contain numbers."
        }
        if matches(lastDot) {
            return "The dot cannot be at the end of the mail name."
        }
        if first == "." {
            return "The dot cannot be the first character of email."
        }

        // Check a resource name
        let resourceNameAllowedCharacters = "@[a-z]+[.]"
        if !matches(resourceNameAllowedCharacters) {
            return "The name of the resource can only contain Latin small letters."
        }

        // Check a domain
        let domain = "[.][a-z]+$"
        if !matches(domain) {
            return "Domain can only contain Latin small letters."
        }
            
        return String()
    }
    
    func checkPassword() -> String {
        
        let minPasswordLength = 6
        let maxPasswordLength = 50
        
        // Regular expressions
        let latinCapitalLetters = "[A-Z]+"
        let numbers = "[0-9]+"
        let specialCharacters = "[!#$%&'*+-/=?^_`{|}()@:;<>~]+"
        let notAllowedCharacters = "[^a-zA-Z0-9!#$%&'*+-/=?^_`{|}()@:;<>~]+"
        var error = String()
        
        if count < minPasswordLength {
            return "The password must be at least 6 characters long."
        }
        if count > maxPasswordLength {
            return "The password cannot be longer than 50 characters."
        }
        if matches(notAllowedCharacters) {
            return "Contains not allowed characters."
        }
        if !matches(latinCapitalLetters) {
            error += "There must be at least one capital Latin letter. "
        }
        if !matches(numbers) {
            error += "There are no numbers. "
        }
        if !matches(specialCharacters) {
            error += "Your input must contain at least one special character. "
        }
        return error
    }
    
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

