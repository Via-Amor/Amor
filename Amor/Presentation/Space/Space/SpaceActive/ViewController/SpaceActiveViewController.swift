//
//  SpaceActiveViewController.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum SpaceActiveViewType {
    case create
    case edit(SpaceSimpleInfo)
    
    var navigationTitle: String {
        switch self {
        case .create:
            return "스페이스 생성"
        case .edit:
            return "스페이스 편집"
        }
    }
}

final class SpaceActiveViewController: BaseVC<SpaceActiveView> {
    let viewModel: SpaceActiveViewModel

    init(viewModel: SpaceActiveViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Design.Chevron.left, style: .plain, target: self, action: nil)
    }

    override func bind() {
        let input = SpaceActiveViewModel.Input(
            viewDidLoadTrigger: Observable<Void>.just(()),
            nameTextFieldText: baseView.nameTextFieldText(),
            descriptionTextFieldText: baseView.descriptionTextFieldText(),
            image: BehaviorRelay<Data>(value: Data()),
            buttonTap: baseView.confirmButtonTap()
        )

        let output = viewModel.transform(input)

        output.navigationTitle
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        output.spaceName
            .bind(onNext: { [weak self] value in
                self?.baseView.setNameTextField(name: value)
            })
            .disposed(by: disposeBag)

        output.spaceDescription
            .bind(onNext: { [weak self] value in
                self?.baseView.setdescriptionTextField(description: value)
            })
            .disposed(by: disposeBag)

        output.spaceImage
            .bind(onNext: { [weak self] value in
                self?.baseView.setSpaceImage(image: value)
            })
            .disposed(by: disposeBag)

        output.confirmButtonEnabled
            .bind(onNext: { [weak self] isEnabled in
                self?.baseView.completeButtonEnabled(isEnabled: isEnabled)
            })
            .disposed(by: disposeBag)
    }
}
