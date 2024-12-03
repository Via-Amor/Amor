//
//  ChatView.swift
//  Amor
//
//  Created by 홍정민 on 11/23/24.
//

import UIKit
import SnapKit

final class ChatView: BaseView {
    let chatTableView = UITableView()
    let chatInputView = ChatInputView()
    
    override func configureHierarchy() {
        addSubview(chatTableView)
        addSubview(chatInputView)
    }
    
    override func configureLayout() {
        chatInputView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).inset(-10)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(chatInputView.snp.top).inset(5)
        }
    }
    
    override func configureView() {
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatTableView.separatorStyle = .none
        
    }
    
    func updateChatAddImageCollectionViewHidden(isHidden: Bool) {
        chatInputView.updateChatAddImageCollectionViewHidden(isHidden: isHidden)
    }
    
    func updateTextViewHeight() {
        chatInputView.updateTextViewHeight()
    }
}

