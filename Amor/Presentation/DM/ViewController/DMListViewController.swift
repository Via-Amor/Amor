//
//  DMListViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DMListViewController: BaseVC<DMListView> {
    
    private let viewModel: DMListViewModel
    
    init(viewModel: DMListViewModel) {
        self.viewModel = viewModel
        super.init() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleButton)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func bind() {
        let input = DMListViewModel.Input(viewWillAppearTrigger: rx.methodInvoked(#selector(self.viewWillAppear)).map { _ in })
        let output = viewModel.transform(input)
        
        output.myImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.spaceImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureSpaceImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.fetchEnd
            .withLatestFrom(output.isEmpty)
            .bind(with: self) { owner, isEmpty in
                owner.baseView.dmUserCollectionView.dataSource = nil
                owner.baseView.dmRoomCollectionView.dataSource = nil
                
                if !isEmpty {
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
                }
                
                owner.baseView.configureEmptyLayout(isEmpty: isEmpty)
            }
            .disposed(by: disposeBag)
        
        baseView.navBar.myProfileButton.rx.tap
            .bind(with: self) { owner, _ in
                // TODO: 변경 필요
                let myProfileViewController = MyProfileViewController(
                    viewModel: MyProfileViewModel(
                        useCase: DefaultUserUseCase(
                            repository: DefaultUserRepository(NetworkManager.shared)
                        )
                    )
                )
                
                owner.navigationController?.pushViewController(myProfileViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
