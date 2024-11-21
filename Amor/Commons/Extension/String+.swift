//
//  String+.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation

extension String {
    func validateRegex(regex: UserRegex) -> Bool {
        if let range = self.range(of: regex.rawValue, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
}
