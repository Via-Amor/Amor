//
//  EditProfileView.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    let profileTextField = {
        let tf = UITextField()
        tf.backgroundColor = .themeWhite
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.rightViewMode = .always
        
        return tf
    }()
    let submitButton = CommonButton(title: "완료", foregroundColor: .themeBlack, backgroundColor: .themeGray)
    
    override func configureHierarchy() {
        addSubview(profileTextField)
        addSubview(submitButton)
    }
    
    override func configureLayout() {
        profileTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(44)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(profileTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-20)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        backgroundColor = .systemGroupedBackground
        
        profileTextField.layer.cornerRadius = 8
        submitButton.isEnabled = false
        submitButton.layer.cornerRadius = 8
    }
}
