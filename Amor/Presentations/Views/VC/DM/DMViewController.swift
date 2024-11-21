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
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func bind() {
        let input = DMViewModel.Input(trigger: BehaviorSubject<Void>(value: ()))
        let output = viewModel.transform(input)
        
        output.myImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.fetchEnd
            .withLatestFrom(output.isEmpty)
            .bind(with: self) { owner, isEmpty in
                switch isEmpty {
                case false:
                    output.spaceMemberArray
                        .bind(to: owner.baseView.dmUserCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (index, element, cell) in
                            
                            cell.configureHierarchy(.spaceMember)
                            cell.configureLayout(.spaceMember)
                            cell.configureSpaceMemberCell(user: element)
                            
                        }
                        .disposed(by: owner.disposeBag)
                    
                    output.dmRoomArray
                        .bind(to: owner.baseView.dmRoomCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (collectionView, element, cell) in
                            
                            cell.configureHierarchy(.dmRoom)
                            cell.configureLayout(.dmRoom)
                            cell.configureDMRoomCell(dmRoom: element)
                        }
                        .disposed(by: owner.disposeBag)
                    
                case true:
                    break
                }
                
                owner.baseView.configureEmptyLayout(isEmpty: isEmpty)
            }
            .disposed(by: disposeBag)
        
        baseView.navBar.myProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                let myProfileViewController = MyProfileViewController(viewModel: MyProfileViewModel(useCase: DefaultMyProfileUseCase(repository: DefaultMyProfileViewRepository())))
                
                owner.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
