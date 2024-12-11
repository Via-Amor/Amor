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
    var coordinator: DMCoordinator?
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
        let fromProfileToDM = PublishSubject<String>()
        let input = DMListViewModel.Input(viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }, fromProfileToDM: fromProfileToDM)
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
        
        output.isEmpty
            .bind(with: self) { owner, value in
                owner.baseView.configureEmptyLayout(isEmpty: value)
            }
            .disposed(by: disposeBag)
        
        output.fetchEnd
            .bind(with: self) { owner, value in
                owner.baseView.dmUserCollectionView.dataSource = nil
                owner.baseView.dmRoomCollectionView.dataSource = nil
                
                output.spaceMemberArray
                    .bind(to: owner.baseView.dmUserCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (index, element, cell) in
                        
                        cell.configureHierarchy(.spaceMember)
                        cell.configureLayout(.spaceMember)
                        cell.configureSpaceMemberCell(user: element)
                        
                    }
                    .disposed(by: owner.disposeBag)
                
                output.dmRoomInfoResult
                    .bind(to: owner.baseView.dmRoomCollectionView.rx.items(cellIdentifier: DMCollectionViewCell.identifier, cellType: DMCollectionViewCell.self)) { (collectionView, element, cell) in
                        
                        cell.configureHierarchy(.dmRoom)
                        cell.configureLayout(.dmRoom)
                        cell.configureDMRoomInfoCell(item: element)
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        baseView.dmUserCollectionView.rx.modelSelected(SpaceMember.self)
            .bind(with: self) { owner, value in
                fromProfileToDM.onNext(value.user_id)
            }
            .disposed(by: disposeBag)
        
        baseView.dmRoomCollectionView.rx.modelSelected((DMRoomInfo, Int).self)
            .bind(with: self) { owner, value in
                owner.coordinator?.showChatFlow(dmRoomInfo: value.0)
            }
            .disposed(by: disposeBag)
        
        output.goChatView
            .bind(with: self) { owner, value in
                owner.coordinator?.showChatFlow(dmRoomInfo: value)
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
