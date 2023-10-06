//
//  StringExtension.swift
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            value: self,
            comment: self
        )
    }
}
