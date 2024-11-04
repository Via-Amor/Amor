//
//  DMViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: DMViewUseCase
    
    init(useCase: DMViewUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let myID = PublishSubject<String>()
        let myImage = PublishSubject<String?>()
        let userArray = BehaviorSubject<[DMSpaceMember]>(value: [])
        let chatArray = BehaviorSubject<[Int]>(value: [])
        
        input.trigger
            .flatMap({ self.useCase.login() })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let login):
                    UserDefaultsStorage.userId = login.user_id
                    UserDefaultsStorage.token = login.token.accessToken
                    UserDefaultsStorage.refresh = login.token.refreshToken
                    myID.onNext(login.user_id)
                    myImage.onNext(login.profileImage)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        myID
            .flatMap({ _ in self.useCase.getSpaceMembers(spaceID: UserDefaultsStorage.spaceId) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let users):
                    userArray.onNext(users)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(myImage: myImage, userArray: userArray, chatArray: chatArray)
    }
}

extension DMViewModel {
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let myImage: PublishSubject<String?>
        let userArray: BehaviorSubject<[DMSpaceMember]>
        let chatArray: BehaviorSubject<[Int]>
    }
}
