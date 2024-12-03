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
    
    let titleInputView = LabeledTextField(
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
//        addSubview(titleInputView)
//        addSubview(descriptionInputView)
//        addSubview(completeButton)
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        backgroundColor = .systemPink
        
    }
    
}
