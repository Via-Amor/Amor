//
//  LabeledTextField.swift
//  Amor
//
//  Created by 양승혜 on 10/28/24.
//

import UIKit
import SnapKit

final class LabeledTextField: UIView {

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Size.title2
        label.textColor = .black
        return label
    }()
    
    private let textField: SignTextField
    
    // MARK: - Initialization
    init(title: String, placeholderText: String, fontSize: UIFont = UIFont.Size.body) {
        self.textField = SignTextField(placeholderText: placeholderText, fontSize: fontSize)
        super.init(frame: .zero)
        
        titleLabel.text = title
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
