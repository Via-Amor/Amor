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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    let dummyLabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.font = UIFont.Size.title2
//        label.text = "DM_VC"
//        return label
//    }()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        view.backgroundColor = .themeGray
//        view.addSubview(dummyLabel)
//        dummyLabel.snp.makeConstraints { make in
//            make.center.equalTo(view.safeAreaLayoutGuide)
//        }
//    }
    
//    override func configureNavigationBar() {
//        navigationItem.titleView
//    }
    
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
