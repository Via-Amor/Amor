//
//  ChatViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatViewModel: BaseViewModel {
    let channel: Channel
    let useCase: ChatUseCase
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let viewWillDisappearTrigger: Observable<Void>
    }
    
    struct Output {
        let navigationContent: Driver<Channel>
        let presentChatList: Driver<[Chat]>
        let presentErrorToast: Signal<Void>
        let initScrollToBottom: Signal<Int>
        let scrollToBottom: Signal<Int>
    }
    
    init(channel: Channel, useCase: ChatUseCase) {
        self.channel = channel
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationContent = BehaviorRelay(value: channel)
        let connectSocket = PublishRelay<Void>()
        let presentChatList = BehaviorRelay<[Chat]>(value: [])
        let presentErrorToast = PublishRelay<Void>()
        let initScrollToBottom = PublishRelay<Int>()
        let scrollToBottom = PublishRelay<Int>()

        connectSocket
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.receiveSocketChannelChat(
                    channelID: self.channel.channel_id
                )
            }
            .flatMap { chat in
                self.useCase.insertPersistChannelChat(chat: chat)
                return self.useCase.fetchPersistChannelChat(
                    channelID: self.channel.channel_id
                )
            }
            .bind(with: self) { owner, chatList in
                presentChatList.accept(chatList)
                scrollToBottom.accept(chatList.count)
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchPersistChannelChat(
                    channelID: self.channel.channel_id
                )
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
                let channelId = self.channel.channel_id
                let request = ChatRequest(
                    workspaceId: spaceId,
                    channelId: channelId,
                    cursor_date: cursorDate
                )
                return request
            }
            .flatMap { request in
                self.useCase.fetchServerChannelChatList(
                    request: request
                )
            }
            .map { result in
                switch result {
                case .success(let value):
                    return value
                case .failure(let error):
                    print("채팅 리스트 서버 조회 오류❌", error)
                    presentErrorToast.accept(())
                    return []
                }
            }
            .map { chatList in
                self.useCase.insertPersistChannelChat(
                    chatList: chatList
                )
            }
            .flatMap { _ in
                self.useCase.fetchPersistChannelChat(
                    channelID: self.channel.channel_id
                )
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
        
        return Output(
            navigationContent: navigationContent.asDriver(),
            presentChatList: presentChatList.asDriver(),
            presentErrorToast: presentErrorToast.asSignal(),
            initScrollToBottom: initScrollToBottom.asSignal(),
            scrollToBottom: scrollToBottom.asSignal()
        )
    }
}
