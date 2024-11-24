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
        let navigationContent: BehaviorRelay<ChannelSummary>
    }
    
    init(channel: Channel, useCase: ChatUseCase) {
        self.channel = channel
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let navigationContent = BehaviorRelay<ChannelSummary>(
            value: ChannelSummary(
                channel_id: channel.channel_id,
                name: channel.name,
                memberCount: 0
            )
        )
        
        input.viewDidLoadTrigger
            .withUnretained(self)
            .map { _ in
                return self.channel.channel_id
            }
            .flatMap {
                self.useCase.fetchChannelDetail(channelID: $0)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    navigationContent.accept(value)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
 
        return Output(
            navigationContent: navigationContent
        )
    }
}
