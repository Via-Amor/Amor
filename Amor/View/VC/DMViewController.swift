//
//  DMViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DMViewController: BaseVC<DMView> {
    
    private let viewModel: DMViewModel
    
    init(viewModel: DMViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.wsImageView), .init(customView: baseView.wsTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.profileImageView)
    }
    
    override func bind() {
        let input = DMViewModel.Input(trigger: BehaviorSubject<Void>(value: ()))
        let output = viewModel.transform(input)
        
        output.userArray
            .bind(to: baseView.dmUserCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (index, element, cell) in
                
                cell.configureHierarchy(.user)
                cell.configureLayout(.user)
                
            }
            .disposed(by: disposeBag)
        
        
        output.chatArray
            .bind(to: baseView.dmChatCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (collectionView, index, cell) in
                
                
                cell.configureHierarchy(.chat)
                cell.configureLayout(.chat)
            }
            .disposed(by: disposeBag)
    }
}
