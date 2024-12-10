//
//  ChangeAdminViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChangeAdminViewController: BaseVC<ChangeAdminView> {
    var coordinator: ChangeAdminCoordinator?
    let viewModel: ChangeAdminViewModel
    let changeAdminTrigger = PublishRelay<String>()
    
    init(viewModel: ChangeAdminViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.changeChannelAdmin
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Design.Icon.xmark,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .themeBlack
    }
    
    override func bind() {
        let input = ChangeAdminViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in },
            memberClicked: baseView.memberCollectionView.rx.modelSelected(ChannelMember.self),
            changeAdminTrigger: changeAdminTrigger
        )
        
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.dismiss()
            }
            .disposed(by: disposeBag)
        
        output.memberList
            .drive(baseView.memberCollectionView.rx.items(
                cellIdentifier: SpaceCollectionViewCell.identifier,
                cellType: SpaceCollectionViewCell.self)) {
                (row, element, cell) in
                cell.configureCell(item: element)
            }
            .disposed(by: disposeBag)
        
        output.presentDisableAlert
            .emit(with: self) { owner, _ in
                owner.coordinator?.showDisableChangeAdminAlert {
                    owner.coordinator?.dismiss()
                }
            }
            .disposed(by: disposeBag)
        
        output.presentChangeAdminAlert
            .emit(with: self) { owner, member in
                owner.coordinator?.showConfirmChangeAdminAlert(
                    nickname: member.nickname,
                    confirmHandler: {
                        owner.changeAdminTrigger.accept(member.user_id)
                    }
                )
            }
            .disposed(by: disposeBag)
        
        output.completeChangeAdmin
            .emit(with: self) { owner, newAdminID in
                owner.coordinator?.dismiss(with: newAdminID)
            }
            .disposed(by: disposeBag)
    }
    
}
