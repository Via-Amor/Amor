//
//  EditChannelViewModel.swift
//  Amor
//
//  Created by 홍정민 on 12/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditChannelViewModel: BaseViewModel {
    private let channelInfo: EditChannel
    private let disposeBag = DisposeBag()
    
    init(editChannel: EditChannel) {
        self.channelInfo = editChannel
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let presentChannelInfo: Signal<EditChannel>
    }
    
    func transform(_ input: Input) -> Output {
        let presentChannelInfo = PublishRelay<EditChannel>()
        
        input.viewWillAppearTrigger
            .bind(with: self) { owner, _ in
                presentChannelInfo.accept(owner.channelInfo)
            }
            .disposed(by: disposeBag)

        return Output(
            presentChannelInfo: presentChannelInfo.asSignal()
        )
    }
}
