//
//  LoginView.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit
import SnapKit

final class LoginView: BaseView {
    private let emailTextField = LabeledTextField(
        title: "이메일",
        placeholderText: "이메일을 입력하세요"
    )
    private let passwordTextField = LabeledTextField(
        title: "비밀번호",
        placeholderText: "비밀번호를 입력하세요"
    )
    private let loginButton = CommonButton(
        title: "로그인",
        foregroundColor: .white,
        backgroundColor: .themeInactive
    )
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        loginButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
}
