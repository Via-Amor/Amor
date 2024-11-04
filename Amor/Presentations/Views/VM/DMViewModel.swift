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
        let myImage = PublishSubject<String?>()
        let userArray = BehaviorSubject<[DMSpaceMember]>(value: [])
        let chatArray = BehaviorSubject<[DMRoom]>(value: [])
        let getUsers = PublishSubject<Void>()
        let getChats = PublishSubject<Void>()
        let isEmpty = PublishRelay<Bool>()
        let fetchEnd = PublishRelay<Void>()
        
        input.trigger
            .flatMap({ self.useCase.login() })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let login):
                    UserDefaultsStorage.userId = login.user_id
                    UserDefaultsStorage.token = login.token.accessToken
                    UserDefaultsStorage.refresh = login.token.refreshToken
                    getUsers.onNext(())
                    getChats.onNext(())
                    myImage.onNext(login.profileImage)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getUsers
            .flatMap({ _ in self.useCase.getSpaceMembers(spaceID: UserDefaultsStorage.spaceId) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let users):
                    var spaceMembers = users.filter({ $0.user_id != UserDefaultsStorage.userId })
                    if spaceMembers.isEmpty {
                        spaceMembers = []
//                        spaceMembers = Array(repeating: DMSpaceMember(DMSpaceMemberDTO(user_id: "4594", email: "", nickname: "개구리", profileImage: "")), count: 10)
                    }
                    userArray.onNext(spaceMembers)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getChats
            .flatMap({ _ in self.useCase.getDMRooms(spaceID: UserDefaultsStorage.spaceId) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dmRooms):
                    if dmRooms.isEmpty {
                        let array: [DMRoom] = []
//                        let array = Array(repeating: DMRoom(DMRoomResponseDTO(room_id: "123", createdAt: "123", user: DMUserResponseDTO(user_id: "123", email: "212", nickname: "새싹이", profileImage: ""))), count: 10)
                        chatArray.onNext(array)
                    } else {
                        chatArray.onNext(dmRooms)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(userArray, chatArray)
            .bind(with: self) { owner, value in
                isEmpty.accept(value.0.isEmpty && value.1.isEmpty)
                fetchEnd.accept(())
            }
            .disposed(by: disposeBag)
        
        
        return Output(myImage: myImage, userArray: userArray, chatArray: chatArray, isEmpty: isEmpty, fetchEnd: fetchEnd)
    }
}

extension DMViewModel {
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let myImage: PublishSubject<String?>
        let userArray: BehaviorSubject<[DMSpaceMember]>
        let chatArray: BehaviorSubject<[DMRoom]>
        let isEmpty: PublishRelay<Bool>
        let fetchEnd: PublishRelay<Void>
    }
}
