//
//  MyProfileViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

final class MyProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: MyProfileUseCase
    
    init(useCase: MyProfileUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let profileImage: PublishSubject<String?>
        let sesacCoin: PublishSubject<Int>
        let phone: PublishSubject<String?>
        let email: PublishSubject<String>
        let provider: PublishSubject<String?>
    }
    
    func transform(_ input: Input) -> Output {
        let profileImage = PublishSubject<String?>()
        let sesacCoin = PublishSubject<Int>()
        let phone = PublishSubject<String?>()
        let email = PublishSubject<String>()
        let provider = PublishSubject<String?>()
        
        input.trigger
            .flatMap({ self.useCase.getMyProfile() })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myProfile):
                    profileImage.onNext(myProfile.profileImage)
                    sesacCoin.onNext(myProfile.sesacCoin)
                    phone.onNext(myProfile.phone)
                    email.onNext(myProfile.email)
                    provider.onNext(myProfile.provider)
                    print(myProfile)
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(profileImage: profileImage, sesacCoin: sesacCoin, phone: phone, email: email, provider: provider)
    }
}
