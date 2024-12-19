//
//  AddMemberView.swift
//  Amor
//
//  Created by 김상규 on 12/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AddMemberView: BaseView {
    private let emailTextField = LabeledTextField(
        title: "이메일",
        placeholderText: "초대하려는 멤버의 이메일을 입력하세요"
    )
    private let addMemberButton = CommonButton(title: "초대", foregroundColor: .themeWhite, backgroundColor: .themeGray)
    
    override func configureHierarchy() {
        addSubview(emailTextField)
        addSubview(addMemberButton)
    }
    
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        addMemberButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        backgroundColor = .backgroundPrimary
    }
    
    func emailTextFieldText() -> ControlProperty<String> {
        return emailTextField.textField.rx.text.orEmpty
    }
    
    func addMemberButtonClicked() -> ControlEvent<Void> {
        return addMemberButton.rx.tap
    }
    
    func addMemberConfiguration(isEnabled: Bool) {
        if isEnabled {
            addMemberButton.configuration?.baseBackgroundColor = .themeGreen
        } else {
            addMemberButton.configuration?.baseBackgroundColor = .themeInactive
        }
        
        addMemberButton.isEnabled = isEnabled
    }
}
