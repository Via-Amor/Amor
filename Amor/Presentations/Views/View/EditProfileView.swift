//
//  EditProfileView.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import UIKit
import SnapKit

final class EditProfileView: BaseView {
    let profileTextField = UITextField()
    let submitButton = CommonButton(title: "완료", foregroundColor: .themeWhite, backgroundColor: .themeGreen)
    
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
            make.height.equalTo(44)
        }
    }
}


enum EditElement {
    case nickname
    case phone
    
    var navigationTitle: String {
        switch self {
        case .nickname:
            return "닉네임"
        case .phone:
            return "연락처"
        }
    }
    
    var placeholder: String {
        switch self {
        case .nickname:
            return "닉네임을 입력해주세요"
        case .phone:
            return "연락처를 입력해주세요"
        }
    }
}

