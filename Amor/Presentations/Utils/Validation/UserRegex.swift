//
//  Regex.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation

enum UserRegex: String {
    case email = #"@[a-zA-Z0-9._%+-]+\.(com|net|co\.kr)"#
    case password = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
}
