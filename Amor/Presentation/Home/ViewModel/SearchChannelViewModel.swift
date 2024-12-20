//
//  SearchChannelViewModel.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchChannelViewModel: BaseViewModel {
    let useCase: ChannelUseCase
    private let disposeBag = DisposeBag()
    
    init(useCase: ChannelUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let selectedChannel: ControlEvent<SearchChannelList>
        let enterNewChannelTrigger: PublishRelay<Channel>
    }
    
    struct Output {
        let spaceChannelList: Driver<[SearchChannelList]>
        let presentChannelChat: Signal<Channel>
        let presentChatEnterAlert: Signal<Channel>
    }
    
    func transform(_ input: Input) -> Output {
        let spaceChannelList = BehaviorRelay<[SearchChannelList]>(value: [])
        let presentChannelChat = PublishRelay<Channel>()
        let presentChatEnterAlert = PublishRelay<Channel>()

        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.useCase.fetchChannelList()
            }
            .bind(with: self) { owner, channelList in
                spaceChannelList.accept(channelList)
            }
            .disposed(by: disposeBag)
        
        input.selectedChannel
            .bind(with: self) { owner, channelList in
                let channel = channelList.toChannel()
                
                if channelList.isAttend {
                    presentChannelChat.accept(channel)
                } else {
                    presentChatEnterAlert.accept(channel)
                }
            }
            .disposed(by: disposeBag)
        
        input.enterNewChannelTrigger
            .bind(with: self) { owner, channel in
                presentChannelChat.accept(channel)
            }
            .disposed(by: disposeBag)
        
        return Output(
            spaceChannelList: spaceChannelList.asDriver(),
            presentChannelChat: presentChannelChat.asSignal(),
            presentChatEnterAlert: presentChatEnterAlert.asSignal()
        )
    }
}
