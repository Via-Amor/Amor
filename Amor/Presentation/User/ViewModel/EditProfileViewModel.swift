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
        let editProfile: BehaviorSubject<ProfileItem>
        let textFieldText: ControlProperty<String>
        let editButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let buttonEnabled: BehaviorRelay<Bool>
    }
    
    private var useCase: UserUseCase
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let buttonEnabled = BehaviorRelay<Bool>(value: false)
        let currentValue = BehaviorSubject<String>(value: "")
        
        let editProfileValue = input.editProfile
            .map({
                guard let value = $0.value else { return ""}
                return value
            })
        
        input.textFieldText
            .bind(to: currentValue)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(currentValue, editProfileValue)
            .bind(with: self) { owner, value in
                if value.0 == value.1 {
                    buttonEnabled.accept(false)
                } else {
                    buttonEnabled.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.editButtonClicked
            .withLatestFrom(input.textFieldText)
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
        
        return Output(buttonEnabled: buttonEnabled)
    }
}
