//
//  DMViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMListViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let userUseCase: UserUseCase
    private let spaceUseCase: SpaceUseCase
    private let dmUseCase: DMUseCase
    
    init(userUseCase: UserUseCase, spaceUseCase: SpaceUseCase, dmUseCase: DMUseCase) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.dmUseCase = dmUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let getSpaceInfo = PublishSubject<Void>()
        let spaceImage = PublishSubject<String?>()
        let myImage = PublishSubject<String?>()
        let spaceMemberArray = BehaviorSubject<[SpaceMember]>(value: [])
        let dmRoomArray = BehaviorSubject<[DMRoom]>(value: [])
        let getSpaceMembers = PublishSubject<Void>()
        let getDms = PublishSubject<Void>()
        let isEmpty = PublishRelay<Bool>()
        let goChatView = PublishRelay<DMRoom>()
        let fetchEnd = PublishRelay<Void>()
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in self.userUseCase.getMyProfile() }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    getSpaceInfo.onNext(())
                    myImage.onNext(success.profileImage)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        getSpaceInfo
            .map { SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap { self.spaceUseCase.getSpaceInfo(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    spaceImage.onNext(success.coverImage)
                    getSpaceMembers.onNext(())
                    getDms.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getSpaceMembers
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap{ self.spaceUseCase.getSpaceMembers(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let users):
                    print("내 아이디", UserDefaultsStorage.userId)
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
            .flatMap({ self.dmUseCase.getDMList(request: $0) })
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
        
        input.dmStartType
            .map { value -> (DMRoomRequestDTO, DMRoomRequestDTOBody) in
                switch value {
                case .dmRoom(let dmRoom):
                    return (DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId), DMRoomRequestDTOBody(opponent_id: dmRoom.user.user_id))
                case .profile(let member):
                    return (DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId), DMRoomRequestDTOBody(opponent_id: member.user_id))
                }
            }
            .flatMap { self.dmUseCase.getDMRoom(request: $0.0, body: $0.1) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    goChatView.accept(success)
                case .failure(let failure):
                    print(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(spaceImage: spaceImage, myImage: myImage, spaceMemberArray: spaceMemberArray, dmRoomArray: dmRoomArray, isEmpty: isEmpty, fetchEnd: fetchEnd, goChatView: goChatView)
    }
}

extension DMListViewModel {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let dmStartType: PublishSubject<DMStartType>
    }
    
    struct Output {
        let spaceImage: PublishSubject<String?>
        let myImage: PublishSubject<String?>
        let spaceMemberArray: BehaviorSubject<[SpaceMember]>
        let dmRoomArray: BehaviorSubject<[DMRoom]>
        let isEmpty: PublishRelay<Bool>
        let fetchEnd: PublishRelay<Void>
        let goChatView: PublishRelay<DMRoom>
    }
}

enum DMStartType {
    case dmRoom(DMRoom)
    case profile(SpaceMember)
}
