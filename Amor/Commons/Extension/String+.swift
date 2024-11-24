//
//  String+.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation

extension String {
    func validateRegex(regex: UserRegex) -> Bool {
        if let _ = self.range(of: regex.rawValue, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
    
    func findRange(str: String) -> NSRange? {
        if let range = self.range(of: str) {
            return NSRange(range, in: self)
        } else {
            return nil
        }
    }
}
