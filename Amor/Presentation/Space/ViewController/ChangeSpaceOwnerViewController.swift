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
    var coordinator: ChangeSpaceOwnerCoordinator?
    let viewModel: ChangeSpaceOwnerViewModel
    var delegate: ChangeSpaceOwnerDelegate?
    
    init(viewModel: ChangeSpaceOwnerViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.Space.changeAdmin.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .xmark,
            style: .plain,
            target: self,
            action: nil
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .themeBlack
    }
    
    override func bind() {
        let changedSpaceOwner = PublishRelay<SpaceMember>()
        let input = ChangeSpaceOwnerViewModel.Input(trigger: BehaviorRelay<Void>(value: ()), changedSpaceOwner: changedSpaceOwner)
        let output = viewModel.transform(input)
        
        output.disabledChangeSpaceOwner
            .bind(with: self) { owner, _ in
                owner.coordinator?.showDisableChangeOwnerAlert {
                    owner.coordinator?.dismissAlertFlow()
                }
            }
            .disposed(by: disposeBag)
        
        output.spaceMember
            .bind(to: baseView.spaceMemberCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) { (index, item, cell) in
                cell.configureCell(item: item)
            }
            .disposed(by: disposeBag)
        
        baseView.spaceMemberCollectionView.rx.modelSelected(SpaceMember.self)
            .bind(with: self) { owner, value in
                owner.coordinator?.showAbleChangeOwnerAlert(memberNickname: value.nickname) {
                    changedSpaceOwner.accept(value)
                }
            }
            .disposed(by: disposeBag)
        
        output.changeOwnerComplete
            .bind(with: self) { owner, value in
                owner.delegate?.changeOwnerCompleteAction()
                owner.coordinator?.dismissAlertFlow(isChanges: true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
protocol ChangeSpaceOwnerDelegate: AnyObject {
    func changeOwnerCompleteAction()
}
