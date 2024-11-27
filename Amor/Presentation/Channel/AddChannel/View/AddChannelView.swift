//
//  AddChannelView.swift
//  Amor
//
//  Created by 김상규 on 11/26/24.
//

import UIKit
import SnapKit

final class AddChannelView: BaseView {
    let channelTitleTextField = LabeledTextField(title: "채널 이름", placeholderText: "채널 이름을 입력하세요 (필수)", fontSize: .body)
    let channelDescriptionTextField = LabeledTextField(title: "채널 설명", placeholderText: "채널을 설명하세요 (옵션)", fontSize: .body)
    let addChannelButton = CommonButton(title: "생성", foregroundColor: .white, backgroundColor: .themeInactive)
    
    override func configureHierarchy() {
        addSubview(channelTitleTextField)
        addSubview(channelDescriptionTextField)
        addSubview(addChannelButton)
    }
    
    override func configureLayout() {
        channelTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        channelDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(channelTitleTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        addChannelButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary
    }
}
