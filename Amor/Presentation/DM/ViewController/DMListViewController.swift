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
        navigationItem.leftBarButtonItems = [
            .init(customView: baseView.navBar.spaceImageView),
            .init(customView: baseView.navBar.spaceTitleButton)
        ]
        
        navigationItem.rightBarButtonItem = .init(
            customView: baseView.navBar.myProfileButton
        )
    }
    
    override func bind() {
        let input = DMListViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in }
        )
        let output = viewModel.transform(input)
        
        output.spaceImage
            .drive(with: self) { owner, value in
                owner.baseView.navBar.configureSpaceImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.profileImage
            .drive(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.spaceMemberArray
            .drive(baseView.dmUserCollectionView.rx.items(
                cellIdentifier: DMUserCollectionViewCell.identifier,
                cellType: DMUserCollectionViewCell.self
            )) { (index, element, cell) in
                cell.configureData(data: element)
            }
            .disposed(by: disposeBag)
        
        output.isSpaceMemberEmpty
            .emit(with: self) { owner, value in
                owner.baseView.configureEmptyLayout(isEmpty: value)
            }
            .disposed(by: disposeBag)
        
        output.presentDmList
            .drive(baseView.dmRoomCollectionView.rx.items(
                cellIdentifier: DMListCollectionViewCell.identifier,
                cellType: DMListCollectionViewCell.self
            )) {
                (collectionView, element, cell) in
                cell.configureDMRoomInfoCell(item: element)
            }
            .disposed(by: disposeBag)
//        
//        baseView.dmUserCollectionView.rx.modelSelected(SpaceMember.self)
//            .bind(with: self) { owner, value in
//                fromProfileToDM.accept(value.user_id)
//            }
//            .disposed(by: disposeBag)
//        
//        baseView.dmRoomCollectionView.rx.modelSelected((DMRoomInfo, Int).self)
//            .bind(with: self) { owner, value in
//                owner.coordinator?.showChatFlow(dmRoomInfo: value.0)
//            }
//            .disposed(by: disposeBag)
//        
//        output.goChatView
//            .bind(with: self) { owner, value in
//                owner.coordinator?.showChatFlow(dmRoomInfo: value)
//            }
//            .disposed(by: disposeBag)
        
        //        baseView.navBar.myProfileButton.rx.tap
        //            .bind(with: self) { owner, _ in
        //                let myProfileViewController = MyProfileViewController(
        //                    viewModel: MyProfileViewModel(
        //                        useCase: DefaultUserUseCase(
        //                            repository: DefaultUserRepository(NetworkManager.shared)
        //                        )
        //                    )
        //                )
        //
        //                owner.navigationController?.pushViewController(myProfileViewController, animated: true)
        //            }
        //            .disposed(by: disposeBag)
    }
}
