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
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.wsImageView), .init(customView: baseView.wsTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.profileImageView)
    }
    
    override func bind() {
        let array1 = ["1","2","3","4","5","6","7","8","9","10"]
        let array2 = [1,2,3,4,5,6,7,8,9,10]
        
        Observable.just(array1)
            .bind(to: baseView.dmUserCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (index, element, cell) in
                
                cell.configureHierarchy(.user)
                cell.configureLayout(.user)
                
            }
            .disposed(by: disposeBag)
        
        
        Observable.just(array2)
            .bind(to: baseView.dmChatCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (collectionView, index, cell) in
                
                
                cell.configureHierarchy(.chat)
                cell.configureLayout(.chat)
            }
            .disposed(by: disposeBag)
    }
}
