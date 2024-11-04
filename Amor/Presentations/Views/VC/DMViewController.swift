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
        navigationItem.leftBarButtonItems = [.init(customView: baseView.spaceImageView), .init(customView: baseView.spaceTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.myProfileButton)
    }
    
    override func bind() {
        let input = DMViewModel.Input(trigger: BehaviorSubject<Void>(value: ()))
        let output = viewModel.transform(input)
        
        output.myImage
            .bind(with: self) { owner, value in
                guard let image = value else {
                    owner.baseView.myProfileButton.setImage(UIImage(named: "User_bot"), for: .normal)
                    return
                }
                
                owner.baseView.myProfileButton.setImage(UIImage(named: image), for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.userArray
            .bind(to: baseView.dmUserCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (index, element, cell) in
                
                cell.configureHierarchy(.user)
                cell.configureLayout(.user)
                cell.configureCell(.user, user: element)
                
            }
            .disposed(by: disposeBag)
        
        
        output.chatArray
            .bind(to: baseView.dmChatCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (collectionView, index, cell) in
                
                
                cell.configureHierarchy(.chat)
                cell.configureLayout(.chat)
            }
            .disposed(by: disposeBag)
        
        baseView.myProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                let myProfileViewController = MyProfileViewController()
                owner.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
