//
//  CustomButtonView.swift
//  Amor
//
//  Created by 양승혜 on 10/27/24.
//

import UIKit
import SnapKit

final class CommonButton: UIButton {
    
    init(
        title: String,
        foregroundColor: UIColor,
        backgroundColor: UIColor
    ) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        let container = AttributeContainer(
            [.font: UIFont.title2]
        )
        configuration.attributedTitle = AttributedString(
            title,
            attributes: container
        )
        configuration.baseForegroundColor = foregroundColor
        configuration.baseBackgroundColor = backgroundColor
        configuration.cornerStyle = .medium
        self.configuration = configuration
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
