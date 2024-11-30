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

protocol SpaceActiveViewDelegate {
    func actionComplete(spaceSimpleInfo: SpaceSimpleInfo)
}

final class SpaceActiveViewController: BaseVC<SpaceActiveView> {
    let viewModel: SpaceActiveViewModel
    var delegate: SpaceActiveViewDelegate?

    init(viewModel: SpaceActiveViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Design.Icon.xmark, style: .plain, target: self, action: nil)
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
            .bind(with: self) { owner, value in
                owner.baseView.setNameTextField(name: value)
            }
            .disposed(by: disposeBag)

        output.spaceDescription
            .bind(with: self) { owner, value in
                owner.baseView.setdescriptionTextField(description: value)
            }
            .disposed(by: disposeBag)

        output.spaceImage
            .bind(with: self) { owner, value in
                owner.baseView.setSpaceImage(image: value)
            }
            .disposed(by: disposeBag)

        output.confirmButtonEnabled
            .bind(with: self) { owner, value in
                owner.baseView.completeButtonEnabled(isEnabled: value)
            }
            .disposed(by: disposeBag)
        
        output.editComplete
            .bind(with: self) { owner, value in
                owner.delegate?.actionComplete(spaceSimpleInfo: value)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
