//
//  ChannelEditView.swift
//  Amor
//
//  Created by 홍정민 on 12/3/24.
//

import UIKit
import SnapKit

final class EditChannelView: BaseView {
    private enum ChannelEditLiteral: String {
        case title = "채널 이름"
        case description = "채널 설명"
        case complete = "완료"
    }
    
    let nameInputView = LabeledTextField(
        title: ChannelEditLiteral.title.rawValue,
        placeholderText: ""
    )
    let descriptionInputView = LabeledTextField(
        title: ChannelEditLiteral.description.rawValue,
        placeholderText: ""
    )
    let completeButton = CommonButton(
        title: ChannelEditLiteral.complete.rawValue,
        foregroundColor: .themeWhite,
        backgroundColor: .themeGreen
    )
    
    override func configureHierarchy() {
        addSubview(nameInputView)
        addSubview(descriptionInputView)
        addSubview(completeButton)
    }
    
    override func configureLayout() {
        nameInputView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        descriptionInputView.snp.makeConstraints { make in
            make.top.equalTo(nameInputView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(nameInputView)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nameInputView)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary
        
    }
    
}
