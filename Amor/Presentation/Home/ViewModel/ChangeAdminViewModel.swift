//
//  ChangeAdminViewModel.swift
//  Amor
//
//  Created by 홍정민 on 12/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeAdminViewModel: BaseViewModel {
    private let channelID: String
    private let useCase: ChannelUseCase
    private let disposeBag = DisposeBag()
    
    init(channelID: String, useCase: ChannelUseCase) {
        self.channelID = channelID
        self.useCase = useCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let memberList: Driver<[ChannelMember]>
        let presentDisableAlert: Signal<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let memberList: BehaviorRelay<[ChannelMember]> = BehaviorRelay(value: [])
        let presentDisableAlert = PublishRelay<Void>()
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .map { _ in
                let request = ChannelRequestDTO(channelId: self.channelID)
                return request
            }
            .flatMap { path in
                self.useCase.members(path: path)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    if value.isEmpty {
                        presentDisableAlert.accept(())
                    } else {
                        memberList.accept(value)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            memberList: memberList.asDriver(),
            presentDisableAlert: presentDisableAlert.asSignal()
        )
    }
}
