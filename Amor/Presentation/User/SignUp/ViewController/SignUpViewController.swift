//
//  SignUpViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/28/24.
//

import UIKit

final class SignUpViewController: UIViewController {
    
    private let greyBar = GreyBarView(frame: .zero)
    private let dummyTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let emailField = LabeledTextField(title: "닉네임", placeholderText: "닉네임을 입력해주세요")
    private let appleButton = CommonButton(title: "Apple로 계속하기", foregroundColor: .white, backgroundColor: .themeBlack)
    private let divider = DividerView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        view.addSubview(greyBar)
        greyBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(dummyTextField)
        dummyTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.top.equalTo(dummyTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // test custom buttton
        view.addSubview(appleButton)
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        // test custom divider
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
