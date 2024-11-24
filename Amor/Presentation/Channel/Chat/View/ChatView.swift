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
    
    override func configureHierarchy() {
        addSubview(chatTableView)
    }
    
    override func configureLayout() {
        chatTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        chatTableView.separatorStyle = .none
    }
}

