//
//  SignTextField.swift
//  Amor
//
//  Created by 양승혜 on 10/27/24.
//

import UIKit
import SnapKit

final class SignTextField: UITextField {
    
    init(placeholderText: String, fontSize: UIFont = UIFont.body) {
        super.init(frame: .zero)
        
        textColor = .black
        placeholder = placeholderText
        textAlignment = .left
        borderStyle = .none
        layer.cornerRadius = 8
        backgroundColor = .themeWhite
        font = fontSize
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
