//
//  UITableViewExtension.swift
//

import UIKit

extension UITableView {
    func configure<T: UITableViewCell>(cell: T.Type, cellString: String, backgroundColor: UIColor, separatorStyle: UITableViewCell.SeparatorStyle, isHidden: Bool, isScrollEnabled: Bool, cornerRadius: CGFloat?) {
        self.register(T.self, forCellReuseIdentifier: cellString)
        self.backgroundColor = backgroundColor
        self.separatorStyle = separatorStyle
        self.isHidden = isHidden
        self.isScrollEnabled = isScrollEnabled
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius ?? 0
    }
}
