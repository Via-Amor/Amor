//
//  ChatViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatViewModel: BaseViewModel {
    let chatType: ChatType
    let useCase: ChatUseCase
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let viewWillDisappearTrigger: Observable<Void>
        let sendButtonTap: ControlEvent<Void>
        let chatText: ControlProperty<String>
        let chatImage: BehaviorRelay<[UIImage]>
        let chatImageName: BehaviorRelay<[String]>
    }
    
    struct Output {
        let navigationContent: Driver<ChatType>
        let presentChatList: Driver<[Chat]>
        let presentErrorToast: Signal<String>
        let clearChatText: Signal<Void>
        let initScrollToBottom: Signal<Int>
        let scrollToBottom: Signal<Int>
    }
    
    init(chatType: ChatType, useCase: ChatUseCase) {
        self.chatType = chatType
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationContent = BehaviorRelay(value: chatType)
        let connectSocket = PublishRelay<Void>()
        let presentChatList = BehaviorRelay<[Chat]>(value: [])
        let presentErrorToast = PublishRelay<String>()
        let clearChatText = PublishRelay<Void>()
        let initScrollToBottom = PublishRelay<Int>()
        let scrollToBottom = PublishRelay<Int>()
        
        connectSocket
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.receiveSocketChat(chatType: self.chatType)
            }
            .flatMap { chat in
                self.useCase.insertPersistChat(chat: chat)
                
                switch self.chatType {
                case .channel(let channel):
                    return self.useCase.fetchPersistChat(
                        id: channel.channel_id
                    )
                    
                case .dm(let dMRoom):
                    return self.useCase.fetchPersistChat(
                        id: dMRoom.room_id
                    )
                }
            }
            .bind(with: self) { owner, chatList in
                presentChatList.accept(chatList)
                scrollToBottom.accept(chatList.count)
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                switch self.chatType {
                case .channel(let channel):
                    self.useCase.fetchPersistChat(
                        id: channel.channel_id
                    )
                    
                case .dm(let dMRoom):
                    self.useCase.fetchPersistChat(
                        id: dMRoom.room_id
                    )
                }
            }
            .map { persistChatList in
                var lstChatDateStr = ""
                if let lstDate = persistChatList.last?.createdAt {
                    lstChatDateStr = lstDate
                }
                return lstChatDateStr
            }
            .map { cursorDate in
                let spaceId = UserDefaultsStorage.spaceId
                let id: String
                let request: ChatRequest
                switch self.chatType {
                case .channel(let channel):
                    id = channel.channel_id
                    request = ChatRequest(
                        workspaceId: spaceId,
                        id: id,
                        cursor_date: cursorDate
                    )
                case .dm(let dMRoom):
                    id = dMRoom.room_id
                    request = ChatRequest(
                        workspaceId: spaceId,
                        id: id,
                        cursor_date: cursorDate
                    )
                }
                return request
            }
            .flatMap { request in
                self.useCase.fetchServerChatList(
                    request: request
                )
            }
            .map { result in
                switch result {
                case .success(let value):
                    return value
                case .failure(let error):
                    print("채팅 리스트 서버 조회 오류 ❌", error)
                    presentErrorToast.accept((ToastText.fetchChatError))
                    return []
                }
            }
            .map { chatList in
                self.useCase.insertPersistChat(
                    chatList: chatList
                )
            }
            .flatMap { _ in
                switch self.chatType {
                case .channel(let channel):
                    self.useCase.fetchPersistChat(
                        id: channel.channel_id
                    )
                case .dm(let dMRoom):
                    self.useCase.fetchPersistChat(
                        id: dMRoom.room_id
                    )
                }
            }
            .bind(with: self) { owner, persistChatList in
                presentChatList.accept(persistChatList)
                initScrollToBottom.accept(persistChatList.count)
                connectSocket.accept(())
            }
            .disposed(by: disposeBag)
        
        input.viewWillDisappearTrigger
            .bind(with: self) { owner, _ in
                owner.useCase.closeSocketConnection()
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTap
            .withLatestFrom(
                Observable.combineLatest(
                    input.chatText,
                    input.chatImage,
                    input.chatImageName
                )
            )
            .filter { value in
                let (text, image, _) = value
                return !text.isEmpty || !image.isEmpty
            }
            .withUnretained(self)
            .map { _, value in
                let (text, image, imageNames) = value
                
                let request: ChatRequest
                
                switch self.chatType {
                case .channel(let channel):
                    request = ChatRequest(
                        workspaceId: UserDefaultsStorage.spaceId,
                        id: channel.channel_id,
                        cursor_date: ""
                    )
                case .dm(let dMRoom):
                    request = ChatRequest(
                        workspaceId: UserDefaultsStorage.spaceId,
                        id: dMRoom.room_id,
                        cursor_date: ""
                    )
                }
                
                let requestBody = ChatRequestBody(
                    content: text,
                    files: image.map {
                        $0.jpegData(compressionQuality: 0.5) ?? Data()
                    },
                    fileNames: imageNames
                )
                
                return (request, requestBody)
            }
            .flatMap { value in
                let (request, body) = value
                return self.useCase.postServerChatList(
                    request: request,
                    body: body
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    print("채팅 전송 ✅")
                    clearChatText.accept(())
                case .failure(let error):
                    print("채팅 전송 오류 ❌", error)
                    presentErrorToast.accept(ToastText.postChatError)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            navigationContent: navigationContent.asDriver(),
            presentChatList: presentChatList.asDriver(),
            presentErrorToast: presentErrorToast.asSignal(),
            clearChatText: clearChatText.asSignal(),
            initScrollToBottom: initScrollToBottom.asSignal(),
            scrollToBottom: scrollToBottom.asSignal()
        )
    }
}
