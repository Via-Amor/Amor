//
//  EditProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: BaseVC<EditProfileView> {
    private let element: ProfileElement
    private let viewModel: EditProfileViewModel
    
    init(element: ProfileElement) {
        self.element = element
        // TODO: 수정 필요
        self.viewModel = EditProfileViewModel(
            useCase: DefaultUserUseCase(
                repository: DefaultUserRepository(NetworkManager.shared)
            )
        )
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(element: element)
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron_left"), style: .plain, target: self, action: nil)
    }
    
    func bind(element: ProfileElement) {
        let editElement = Observable.just(element)
        
        editElement
            .bind(with: self) { owner, value in
                owner.navigationItem.title = value.profileElement.elementName
                owner.baseView.profileTextField.placeholder = value.profileElement.placeholder
                owner.baseView.profileTextField.text = value.value
                owner.baseView.submitButton.configuration?.baseForegroundColor = .themeBlack
                owner.baseView.submitButton.configuration?.baseBackgroundColor = .themeGray
                owner.baseView.submitButton.rx.isEnabled.onNext(false)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        let input = EditProfileViewModel.Input(editProfile: BehaviorSubject<ProfileElement>(value: element), textFieldText: baseView.profileTextField.rx.text.orEmpty, editButtonClicked: baseView.submitButton.rx.tap)
        let output = viewModel.transform(input)
        
        output.buttonEnabled
            .bind(with: self) { owner, value in
                owner.baseView.submitButton.configuration?.baseForegroundColor = value ? .themeWhite : .themeBlack
                owner.baseView.submitButton.configuration?.baseBackgroundColor = value ? .themeGreen : .themeGray
                owner.baseView.submitButton.rx.isEnabled.onNext(value)
            }
            .disposed(by: disposeBag)
    }
}
