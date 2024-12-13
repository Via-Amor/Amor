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
    private let userUseCase: UserUseCase
    private let spaceUseCase: SpaceUseCase
    private let dmUseCase: DMUseCase
    private let chatUseCase: ChatUseCase
    private let disposeBag = DisposeBag()
    
    init(
        userUseCase: UserUseCase,
        spaceUseCase: SpaceUseCase,
        dmUseCase: DMUseCase,
        chatUseCase: ChatUseCase
    ) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.dmUseCase = dmUseCase
        self.chatUseCase = chatUseCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let spaceImage: Driver<String?>
        let profileImage: Driver<String?>
        let spaceMemberArray: Driver<[SpaceMember]>
        let isSpaceMemberEmpty: Signal<Bool>
        let presentDmList: Driver<[DMListContent]>
    }
    
    func transform(_ input: Input) -> Output {
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let profileImage = BehaviorRelay<String?>(value: nil)
        let spaceMemberArray = BehaviorRelay<[SpaceMember]>(value: [])
        let isSpaceMemberEmpty = PublishRelay<Bool>()
        let presentDmList = BehaviorRelay<[DMListContent]>(value: [])
        
        let profile = input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.userUseCase.getMyProfile()
            }
        
        let space = input.viewWillAppearTrigger
            .withUnretained(self)
            .map { _ in
                let request = SpaceRequestDTO(
                    workspace_id: UserDefaultsStorage.spaceId
                )
                return request
            }
            .flatMap { request in
                self.spaceUseCase.getSpaceInfo(request: request)
            }
        
        let dmList = input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.dmUseCase.fetchDMRoomList(
                    request: DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
                )
            }
            .flatMap { result in
                switch result {
                case .success(let value):
                    let dmList = value.map { room in
                        
                        // 채팅 리스트 (DB)
                        let persistChatList = self.chatUseCase.fetchPersistDMChat(id: room.room_id)
                            .asObservable()
                        
                        // 채팅 리스트 (서버)
                        let serverChatList = persistChatList
                            .map { chat in
                                return chat.last?.createdAt ?? ""
                            }
                            .map { lastChatDate in
                                return ChatRequest(
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    id: room.room_id,
                                    cursor_date: lastChatDate
                                )
                            }
                            .flatMap { request in
                                self.chatUseCase.fetchServerDMChatList(
                                    request: request
                                )
                            }
                            .flatMap { result -> Observable<[Chat]> in
                                switch result {
                                case .success(let value):
                                    return .just(value)
                                case .failure(let error):
                                    print(error)
                                    return .never()
                                }
                            }
                        
                        // 안읽은 채팅 개수
                        let unReadCount = persistChatList
                            .map { chat in
                                return chat.last?.createdAt ?? ""
                            }
                            .map { lastChatDate in
                                return UnreadDMRequst(
                                    id: room.room_id,
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    after: lastChatDate
                                )
                            }
                            .flatMap { request in
                                self.dmUseCase.fetchUnreadDMCount(request: request)
                            }
                            .flatMap { result -> Observable<Int> in
                                switch result {
                                case .success(let value):
                                    return .just(value.count)
                                case .failure(let error):
                                    print(error)
                                    return .just(0)
                                }
                            }
                        
                        let dmListContent = Observable.zip(persistChatList, serverChatList, unReadCount)
                            .map { (persistList, serverList, count) in
                                var lastChat: Chat?
                                
                                if serverList.isEmpty {
                                    lastChat = persistList.last
                                } else {
                                    lastChat = serverList.last
                                }
                                
                                return DMListContent(
                                    room_id: room.room_id,
                                    profileImage: room.user.profileImage,
                                    nickname: room.user.nickname,
                                    content: lastChat?.content ?? "",
                                    unreadCount: count,
                                    createdAt: lastChat?.createdAt ?? "",
                                    files: lastChat?.files ?? []
                                )
                            }
                        return dmListContent
                    }
                    return Observable.zip(dmList)
                case .failure(let error):
                    print(error)
                    return Observable.never()
                }
            }
        
        dmList
            .bind(with: self) { owner, dmList in
                let filteredDMList = dmList.filter {
                    let createdAt = $0.createdAt
                    let content = $0.content ?? ""
                    
                    return !createdAt.isEmpty && !content.isEmpty
                }
                presentDmList.accept(filteredDMList)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(profile, space)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                switch value {
                case (.success(let profile), .success(let space)):
                    profileImage.accept(profile.profileImage)
                    
                    spaceImage.accept(space.coverImage)
                    let spaceMember = space.workspaceMembers.filter {
                        $0.user_id != UserDefaultsStorage.userId
                    }
                    isSpaceMemberEmpty.accept(spaceMember.isEmpty)
                    spaceMemberArray.accept(spaceMember)
                default:
                    print("DM 리스트 조회 오류")
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            spaceImage: spaceImage.asDriver(),
            profileImage: profileImage.asDriver(),
            spaceMemberArray: spaceMemberArray.asDriver(),
            isSpaceMemberEmpty: isSpaceMemberEmpty.asSignal(),
            presentDmList: presentDmList.asDriver()
        )
    }
}
