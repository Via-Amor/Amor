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
    private let useCase: DMUseCase
    
    init(useCase: DMUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let myImage = PublishSubject<String?>()
        let spaceMemberArray = BehaviorSubject<[SpaceMember]>(value: [])
        let dmRoomArray = BehaviorSubject<[DMRoom]>(value: [])
        let getSpaceMembers = PublishSubject<Void>()
        let getDms = PublishSubject<Void>()
        let isEmpty = PublishRelay<Bool>()
        let fetchEnd = PublishRelay<Void>()
        
        input.trigger
//            .map { LoginRequestDTO(email: "qwe123@gmail.com", password: "Qwer1234!") }
//            .flatMap({ self.useCase.login(request: $0) })
            .bind(with: self) { owner, result in
//                switch result {
//                case .success(let login):
//                    UserDefaultsStorage.userId = login.user_id
//                    UserDefaultsStorage.token = login.token.accessToken
//                    UserDefaultsStorage.refresh = login.token.refreshToken
                    getSpaceMembers.onNext(())
                    getDms.onNext(())
//                    myImage.onNext(login.profileImage)
//                case .failure(let error):
//                    print(error)
//                }
            }
            .disposed(by: disposeBag)
        
        getSpaceMembers
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap{ self.useCase.getSpaceMembers(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let users):
                    var spaceMembers = users.filter({ $0.user_id != UserDefaultsStorage.userId })
                    if spaceMembers.isEmpty {
                        spaceMembers = []
                    }
                    spaceMemberArray.onNext(spaceMembers)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getDms
            .map { DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap({ self.useCase.getDMRooms(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dmRooms):
                    if dmRooms.isEmpty {
                        let array: [DMRoom] = []
                        dmRoomArray.onNext(array)
                    } else {
                        dmRoomArray.onNext(dmRooms)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(spaceMemberArray, dmRoomArray)
            .bind(with: self) { owner, value in
                isEmpty.accept(value.0.isEmpty && value.1.isEmpty)
                fetchEnd.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(myImage: myImage, spaceMemberArray: spaceMemberArray, dmRoomArray: dmRoomArray, isEmpty: isEmpty, fetchEnd: fetchEnd)
    }
}

extension DMViewModel {
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let myImage: PublishSubject<String?>
        let spaceMemberArray: BehaviorSubject<[SpaceMember]>
        let dmRoomArray: BehaviorSubject<[DMRoom]>
        let isEmpty: PublishRelay<Bool>
        let fetchEnd: PublishRelay<Void>
    }
}
