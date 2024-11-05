//
//  EditProfileViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let editElement: BehaviorSubject<EditElement>
        let textFieldText: ControlProperty<String>
    }
    
    struct Output {
        let navigationTitle: BehaviorSubject<String>
        let placeholder: BehaviorSubject<String>
    }
    
    private var useCase: EditProfileUseCase
    
    init(useCase: EditProfileUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationTitle = BehaviorSubject<String>(value: "")
        let placeholder = BehaviorSubject<String>(value: "")
        
        input.editElement
            .bind(with: self) { owner, value in
                navigationTitle.onNext(value.navigationTitle)
                placeholder.onNext(value.placeholder)
            }
            .disposed(by: disposeBag)
        
        input.textFieldText
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(navigationTitle: navigationTitle, placeholder: placeholder)
    }
}
