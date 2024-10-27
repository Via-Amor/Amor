//
//  SignTextField.swift
//  Amor
//
//  Created by 양승혜 on 10/27/24.
//

import UIKit
import SnapKit

class SignTextField: UITextField {
    
    init(placeholderText: String, fontSize: CGFloat = 16) {
        super.init(frame: .zero)
        
        textColor = .black
        placeholder = placeholderText
        textAlignment = .center
        borderStyle = .none
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        font = .systemFont(ofSize: fontSize)
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
