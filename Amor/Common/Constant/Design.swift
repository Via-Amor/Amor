//
//  Design.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import UIKit

enum Design {
    enum TabImage {
        static let homeSelected = UIImage(named: "Home_selected")!
        static let homeUnselected = UIImage(named: "Home_unselected")!
        static let dmSelected = UIImage(named: "DM_selected")!
        static let dmUnselected = UIImage(named: "DM_unselected")!
        static let searchSelected = UIImage(named: "Search_selected")!
        static let searchUnselected = UIImage(named: "Search_unselected")!
        static let settingSelected = UIImage(named: "Setting_selected")!
        static let settingUnselected = UIImage(named: "Setting_unselected")!
    }
    
    enum Chevron {
        static let left = UIImage(named: "Chevron_left")!
        static let right = UIImage(named: "Chevron_right")!
        static let up = UIImage(named: "Chevron_up")!
        static let down = UIImage(named: "Chevron_down")!
    }
    
    enum Icon {
        static let hashtagLight = UIImage(named: "Hashtag_light")!
        static let hashtagBold = UIImage(named: "Hashtag_bold")!
        static let plus = UIImage(named: "PlusMark")!
        static let xmark = UIImage(named: "Xmark")?.withTintColor(.themeBlack, renderingMode: .alwaysOriginal)
        static let threeDots = UIImage(named: "ThreeDots")!
    }
    
    enum Empty {
        static let image = UIImage(named: "onboarding")
    }
}
