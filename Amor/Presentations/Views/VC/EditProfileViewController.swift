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
    var element: EditElement?
    
    let viewModel: EditProfileViewModel
    
    init(element: EditElement?, viewModel: EditProfileViewModel) {
        self.element = element
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Chevron_left"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    override func bind() {
        let input = EditProfileViewModel.Input(editElement: BehaviorSubject<EditElement>(value: element ?? .phone), textFieldText: baseView.profileTextField.rx.text.orEmpty)
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.navigationTitle
            .bind(with: self) { owner, value in
                owner.navigationItem.title = value
            }
            .disposed(by: disposeBag)
        
        output.placeholder
            .bind(with: self) { owner, value in
                owner.baseView.profileTextField.placeholder = value
            }
            .disposed(by: disposeBag)
    }
}
