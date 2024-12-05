//
//  ChangeSpaceOwnerViewController.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeSpaceOwnerViewController: BaseVC<ChangeSpaceOwnerView> {
    var coordinator: SideSpaceMenuCoordinator?
    let viewModel: ChangeSpaceOwnerViewModel
    
    init(viewModel: ChangeSpaceOwnerViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.changeSpaceOwner
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Design.Icon.xmark, style: .plain, target: self, action: nil)
    }
    
    override func bind() {
        let input = ChangeSpaceOwnerViewModel.Input(trigger: BehaviorRelay<Void>(value: ()))
        let output = viewModel.transform(input)
        
        output.disabledChangeSpaceOwner
            .bind(with: self) { owner, _ in
                owner.coordinator?.showAlertFlow(title: AlertText.ChangeSpaceOwnerAlertText.title, subtitle: AlertText.ChangeSpaceOwnerAlertText.description, alertType: .oneButton) {
                    owner.coordinator?.dismissAlertFlow()
                }
            }
            .disposed(by: disposeBag)
        
        output.spaceMember
            .bind(to: baseView.spaceMemberCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell(item: item)
            }
            .disposed(by: disposeBag)
            
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
