//
//  BorderRadiusButton.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import UIKit
import SnapKit

final class BorderRadiusButton: UIButton {
    enum BorderButtonType {
        case plain
        case destructive
        
        var color: UIColor {
            switch self {
            case .plain:
                return .themeBlack
            case .destructive:
                return .themeError
            }
        }
    }
    
    let borderButtonType: BorderButtonType

    init(borderButtonType: BorderButtonType = .plain) {
        self.borderButtonType = borderButtonType
        super.init(frame: .zero)
        configureHeight()
        configureBorder()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeight() {
        snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    private func configureBorder() {
        var configuration = UIButton.Configuration.plain()
        configuration.background.cornerRadius = 8
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = borderButtonType.color
        configuration.baseForegroundColor = borderButtonType.color
        self.configuration = configuration
    }
    
    func configureTitle(title: String) {
        let attribute = AttributeContainer(
            [.font: UIFont.title2]
        )
        let attributedTitle = AttributedString(
            title,
            attributes: attribute
        )
        configuration?.attributedTitle = attributedTitle
    }
    
}

