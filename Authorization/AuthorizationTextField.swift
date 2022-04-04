//
//  AuthorizationTextField.swift
//  Authorization
//
//  Created by myronishyn.ihor on 03.04.2022.
//

import UIKit

class AuthorizationTextField: UITextField {
    var isValid = false
    let sideSpacing: CGFloat = 12.0
    let rightViewWidth: CGFloat = 25.0
    lazy var offset: CGFloat = sideSpacing * 3 + rightViewWidth
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if tag != 1 && tag != 4 {
            return CGRect(x: sideSpacing, y: 0, width: frame.width - sideSpacing * 2, height: bounds.height)
        }
        return CGRect(x: sideSpacing, y: 0, width: frame.width - offset, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: sideSpacing, y: 0, width: frame.width - offset, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: frame.width - rightViewWidth - sideSpacing, y: 0, width: rightViewWidth, height: bounds.height)
    }
}
