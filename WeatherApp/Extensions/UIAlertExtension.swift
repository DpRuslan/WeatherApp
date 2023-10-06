//
//  UIAlertExtension.swift
//

import UIKit

extension UIAlertController {
    static func informativeAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title.localized(), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        return alertController
    }
}
