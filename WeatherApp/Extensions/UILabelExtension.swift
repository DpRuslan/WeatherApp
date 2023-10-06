//
//  UILabelExtension.swift
//

import UIKit

extension UILabel {
    func setStyle(textColor: UIColor, font: UIFont, isHidden: Bool) {
        self.textColor = textColor
        self.font = font
         self.isHidden = isHidden
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
