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
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let navigationContent: Driver<Channel>
        let presentChatList: Driver<[Chat]>
    }
    
    init(channel: Channel, useCase: ChatUseCase) {
        self.channel = channel
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationContent = BehaviorRelay(value: channel)
        let fetchPersistChatList = BehaviorRelay<Void>(value: ())
        let fetchServerChatList = BehaviorRelay<String>(value: "")
        let insertPersistChatList = BehaviorRelay<[Chat]>(value: [])
        let refetchPersistChatList = BehaviorRelay<Void>(value: ())
        let presentChatList = BehaviorRelay<[Chat]>(value: [])
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                fetchPersistChatList.accept(())
            }
            .disposed(by: disposeBag)
        
        // DB에 저장된 채팅내역 조회
        fetchPersistChatList
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchPersistChannelChat(
                    channelID: self.channel.channel_id
                )
            }
            .bind(with: self) { owner, chatList in
                var lstChatDateStr = ""
                if let lstDate = chatList.last?.createdAt {
                    lstChatDateStr = lstDate
                }
                fetchServerChatList.accept(lstChatDateStr)
            }
            .disposed(by: disposeBag)
        
        // 서버에 저장된 채팅내역 조회
        fetchServerChatList
            .withUnretained(self)
            .map { _ , cursorDate in
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
                self.useCase.fetchServerChannelChatList(request: request)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    insertPersistChatList.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // DB에 채팅 내역 저장
        insertPersistChatList
            .bind(with: self) { owner, chatList in
                owner.useCase.insertPersistChannelChat(chatList: chatList)
                refetchPersistChatList.accept(())
            }
            .disposed(by: disposeBag)
        
        // DB 재조회 및 채팅 내용 출력
        refetchPersistChatList
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchPersistChannelChat(
                    channelID: self.channel.channel_id
                )
            }
            .bind(with: self) { owner, chatList in
                presentChatList.accept(chatList)
            }
            .disposed(by: disposeBag)
 
        return Output(
            navigationContent: navigationContent.asDriver(),
            presentChatList: presentChatList.asDriver()
        )
    }
}
