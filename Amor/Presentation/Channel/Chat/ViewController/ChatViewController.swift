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
    let viewModel: ChatViewModel
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .themeWhite
        tabBarController?.tabBar.isHidden = true
    }
    
    // 우측 바버튼 설정
    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Design.TabImage.homeSelected,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    // 네비게이션 영역 타이틀 설정
    private func configureNavigationContent(_ content: Channel) {
        let channelName = content.name
//        let memberCount = content.memberCount.formatted()
        let titleName = channelName
        
        let attributedTitle = NSMutableAttributedString(string: titleName)
//        attributedTitle.addAttribute(
//            .font,
//            value: UIFont.boldSystemFont(ofSize: 17),
//            range: titleName.findRange(str: titleName)!
//        )
        
//        if let range = titleName.findRange(str: memberCount) {
//            attributedTitle.addAttribute(.foregroundColor, value: UIColor.textSecondary, range: range)
//        }
//        
        let titleLabel = UILabel()
        titleLabel.attributedText = attributedTitle
        navigationItem.titleView = titleLabel
    }
    
    override func bind() {
        let input = ChatViewModel.Input(
            viewDidLoadTrigger: Observable.just(())
        )
        
        let output = viewModel.transform(input)
        
        output.navigationContent
            .drive(with: self) { owner, content in
                owner.configureNavigationContent(content)
            }
            .disposed(by: disposeBag)
        
        output.presentChatList
            .drive(baseView.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.identifier, cellType: ChatTableViewCell.self)) { (row, element, cell) in
               cell.configureData(data: element)
               cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
    }
    
}
