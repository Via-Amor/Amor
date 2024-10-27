//
//  CustomButtonView.swift
//  Amor
//
//  Created by 양승혜 on 10/27/24.
//

import UIKit
import SnapKit

final class CommonButton: UIButton {
    
    init(title: String, foregroundColor: UIColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseForegroundColor = foregroundColor
        configuration.baseBackgroundColor = backgroundColor
        configuration.cornerStyle = .medium
        self.configuration = configuration
        //self.heightAnchor.constraint(equalToConstant: 40).isActive = true // button의 높이를 고정
//        self.snp.makeConstraints { make in
//            make.height.equalTo(40)
//        } // snapkit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
