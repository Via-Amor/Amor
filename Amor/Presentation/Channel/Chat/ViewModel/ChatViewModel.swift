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
    private let chatList: [Chat] = []
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let navigationContent: Driver<Channel>
        let savedChatList: Driver<[Chat]>
    }
    
    init(channel: Channel, useCase: ChatUseCase) {
        self.channel = channel
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationContent = BehaviorRelay(value: channel)
        let fetchPersistChatList = BehaviorRelay<Void>(value: ())
        let savedChatList = BehaviorRelay<[Chat]>(value: chatList)
        
        input.viewDidLoadTrigger
            .bind(with: self) { owner, _ in
                fetchPersistChatList.accept(())
            }
            .disposed(by: disposeBag)
        
        // DB에 저장된 채팅내역 조회
        fetchPersistChatList
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchPersistChannelChat()
            }
            .bind(with: self) { owner, chatList in
                print(chatList)
            }
            .disposed(by: disposeBag)
        
        
 
        return Output(
            navigationContent: navigationContent.asDriver(),
            savedChatList: savedChatList.asDriver()
        )
    }
}
