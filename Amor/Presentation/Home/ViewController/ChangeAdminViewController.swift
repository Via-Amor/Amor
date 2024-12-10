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
                .map { _ in }
        )
        
        let output = viewModel.transform(input)
        
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
    }
    
}
