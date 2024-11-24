//
//  ChatViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatViewController: BaseVC<ChatView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    

    override func configureNavigationBar() {
        let chatName = "#그냥 떠들고 싶을 때"
        let participant = 14
        let titleName = chatName + " \(participant)"
        
        let attributedTitle = NSMutableAttributedString(string: titleName)
        attributedTitle.addAttribute(
            .font,
            value: UIFont.boldSystemFont(ofSize: 17),
            range: titleName.findRange(str: titleName)!
        )
        
        if let range = titleName.findRange(str: "\(participant)") {
            attributedTitle.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: range)
        }
        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedTitle
        navigationItem.titleView = titleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Home_selected"),
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    override func bind() {
        Observable.just(chatList)
            .bind(to: baseView.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { (row, element, cell) in
               cell.configureData(data: element)
               cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension ChatViewController {
    private func configureView() {
        view.backgroundColor = .themeWhite
        tabBarController?.tabBar.isHidden = true
        
    }
}
