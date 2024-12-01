//
//  NavigationBarType.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation

enum NavigationBarType {
    case home(String)
    case dm
    
    var title: String {
        switch self {
        case .home(let string):
            string
        case .dm:
            "Direct Message"
        }
    }
}
