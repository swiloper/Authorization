//
//  ErrorAlert.swift
//  Authorization
//
//  Created by myronishyn.ihor on 05.04.2022.
//

import UIKit

class ErrorAlert {
    static func createController(message: String) -> UIAlertController {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        return controller
    }
}
