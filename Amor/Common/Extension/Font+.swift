//
//  Font+.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit

enum FontName {
    static let moneygraphy = "Moneygraphy-Rounded"
}

extension UIFont {
    static let navigation: UIFont = UIFont(name: FontName.moneygraphy, size: 22)!
    static let title1: UIFont = .systemFont(ofSize: 22, weight: .bold)
    static let title2: UIFont = .systemFont(ofSize: 14, weight: .bold)
    static let bodyBold: UIFont = .systemFont(ofSize: 13, weight: .bold)
    static let body: UIFont = .systemFont(ofSize: 13, weight: .regular)
    static let caption: UIFont = .systemFont(ofSize: 12, weight: .regular)
    static let mini: UIFont = .systemFont(ofSize: 11, weight: .regular)
    static let miniBold: UIFont = .systemFont(ofSize: 11, weight: .medium)
}
