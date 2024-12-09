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
    private let chatUseCase: ChatUseCase
    
    init(userUseCase: UserUseCase, spaceUseCase: SpaceUseCase, dmUseCase: DMUseCase, chatUseCase: ChatUseCase) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.dmUseCase = dmUseCase
        self.chatUseCase = chatUseCase
    }
    
    func transform(_ input: Input) -> Output {
        let getSpaceInfo = PublishSubject<Void>()
        let spaceImage = PublishSubject<String?>()
        let myImage = PublishSubject<String?>()
        let spaceMemberArray = BehaviorSubject<[SpaceMember]>(value: [])
        let getSpaceMembers = PublishSubject<Void>()
        let getDms = PublishSubject<Void>()
        let dmRoomArray = BehaviorSubject<[DMRoom]>(value: [])
        let dmRoomInfoArray = BehaviorSubject<[DMRoomInfo]>(value: [])
        let isEmpty = PublishRelay<Bool>()
        let goChatView = PublishRelay<DMRoomInfo>()
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
                        dmRoomInfoArray.onNext([])
                    } else {
                        dmRoomArray.onNext(dmRooms)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        dmRoomArray
            .map{
                return ($0, $0.map { ChatRequestDTO(workspaceId: UserDefaultsStorage.spaceId, id: $0.room_id, cursor_date: Date().toServerDateStr())})
            }
            .flatMap { [weak self] (dmRooms, requests) -> Observable<([DMRoom], [[Chat]], [[Chat]])> in
                guard let self = self else {
                    return Observable.zip(
                        Observable.just(dmRooms),
                        Observable.just([]),
                        Observable.just([])
                    )
                }
                
                let serverChats = self.dmUseCase.getServerDMs(requests: requests)
                
                // 데이터베이스 채팅 가져오기
                let persistChats = Observable.from(dmRooms)
                    .flatMap {
                        self.chatUseCase.fetchPersistChat(id: $0.room_id)
                    }
                    .flatMap {
                        self.dmUseCase.getRecentPersistDMs(chats: $0)
                    }
                    .toArray()
                    .asObservable()

                return Observable.zip(
                    Observable.just(dmRooms),
                    serverChats,
                    persistChats
                )
            }
            .map { dmRooms, serverChats, persistChats -> [DMRoomInfo] in
                return dmRooms.enumerated().compactMap { index, room in
                    let serverChat = serverChats[index].first
                    let persistChat = persistChats[index].first

                    let chats = [serverChat, persistChat].filter({ $0?.id == room.room_id }).compactMap { $0 }
                    
                    guard let latestChat = chats.max(by: { lhs, rhs in
                        lhs.createdAt.toServerDate() < rhs.createdAt.toServerDate()
                    }) else { return nil }
                    
                    return DMRoomInfo(
                        room_id: room.room_id,
                        nickname: room.user.nickname,
                        profileImage: room.user.profileImage,
                        content: latestChat.content,
                        createdAt: latestChat.createdAt,
                        files: latestChat.files
                    )
                }
            }
            .bind(to: dmRoomInfoArray)
            .disposed(by: disposeBag)
        
        Observable.zip(spaceMemberArray, dmRoomInfoArray)
            .bind(with: self) { owner, value in
                isEmpty.accept(value.0.isEmpty && value.1.isEmpty)
                fetchEnd.accept(())
            }
            .disposed(by: disposeBag)
        
        input.fromProfileToDM
            .map {
                return (DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId), DMRoomRequestDTOBody(opponent_id: $0))
            }
            .flatMap {
                self.dmUseCase.getDMRoom(request: $0.0, body: $0.1)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    let dmRoomInfo = DMRoomInfo(room_id: success.room_id, nickname: success.user.nickname, profileImage: success.user.profileImage, content: nil, createdAt: "", files: [])
                    goChatView.accept(dmRoomInfo)
                case .failure(let failure):
                    print(failure)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(spaceImage: spaceImage, myImage: myImage, spaceMemberArray: spaceMemberArray, dmRoomInfoArray: dmRoomInfoArray, isEmpty: isEmpty, fetchEnd: fetchEnd, goChatView: goChatView)
    }
}

extension DMListViewModel {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let fromProfileToDM: PublishSubject<String>
    }
    
    struct Output {
        let spaceImage: PublishSubject<String?>
        let myImage: PublishSubject<String?>
        let spaceMemberArray: BehaviorSubject<[SpaceMember]>
        let dmRoomInfoArray: BehaviorSubject<[DMRoomInfo]>
        let isEmpty: PublishRelay<Bool>
        let fetchEnd: PublishRelay<Void>
        let goChatView: PublishRelay<DMRoomInfo>
    }
}
