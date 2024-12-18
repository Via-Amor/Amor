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
    }
    
    struct Output {
        let presentChannelList: Driver<[ChannelList]>
    }
    
    func transform(_ input: Input) -> Output {
        let presentChannelList = BehaviorRelay<[ChannelList]>(value: [])

        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.useCase.fetchChannelList()
            }
            .bind(with: self) { owner, channelList in
                presentChannelList.accept(channelList)
            }
            .disposed(by: disposeBag)
        
        return Output(presentChannelList: presentChannelList.asDriver())
    }
}
