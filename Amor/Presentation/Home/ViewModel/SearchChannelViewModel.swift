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
        let selectedChannel: ControlEvent<ChannelList>
    }
    
    struct Output {
        let spaceChannelList: Driver<[ChannelList]>
        let presentChannelChat: Signal<Channel>
    }
    
    func transform(_ input: Input) -> Output {
        let spaceChannelList = BehaviorRelay<[ChannelList]>(value: [])
        let presentChannelChat = PublishRelay<Channel>()

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
            .map { channelList in
                return channelList.toChannel()
            }
            .bind(with: self) { owner, channel in
                presentChannelChat.accept(channel)
            }
            .disposed(by: disposeBag)
        
        return Output(
            spaceChannelList: spaceChannelList.asDriver(),
            presentChannelChat: presentChannelChat.asSignal()
        )
    }
}
