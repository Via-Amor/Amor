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
        chatTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        chatInputView.snp.makeConstraints { make in
            make.top.equalTo(chatTableView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    override func configureView() {
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatTableView.separatorStyle = .none
        
    }
}

