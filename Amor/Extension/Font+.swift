//
//  Font+.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit

extension UIFont {
    // MARK: - Font Sizes
    enum Size {
        static let title1: CGFloat = 22
        static let title2: CGFloat = 14
        static let bodyBold: CGFloat = 13
        static let body: CGFloat = 13
        static let caption: CGFloat = 12
    }
    
    // MARK: - custom font methods
    static func title1() -> UIFont {
        return .systemFont(ofSize: Size.title1, weight: .bold)
    }
    
    static func title2() -> UIFont {
        return .systemFont(ofSize: Size.title2, weight: .bold)
    }
    
    static func bodyBold() -> UIFont {
        return .systemFont(ofSize: Size.bodyBold, weight: .bold)
    }
    
    static func body() -> UIFont {
        return .systemFont(ofSize: Size.body, weight: .regular)
    }
    
    static func caption() -> UIFont {
        return .systemFont(ofSize: Size.caption, weight: .regular)
    }
}
