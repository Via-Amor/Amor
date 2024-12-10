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
        let memberClicked: ControlEvent<ChannelMember>
        let changeAdminTrigger: PublishRelay<String>
    }
    
    struct Output {
        let memberList: Driver<[ChannelMember]>
        let presentDisableAlert: Signal<Void>
        let presentChangeAdminAlert: Signal<ChannelMember>
        let completeChangeAdmin: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let memberList: BehaviorRelay<[ChannelMember]> = BehaviorRelay(value: [])
        let presentDisableAlert = PublishRelay<Void>()
        let presentChangeAdminAlert = PublishRelay<ChannelMember>()
        let completeChangeAdmin = PublishRelay<String>()
        
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
        
        input.memberClicked
            .bind(with: self) { owner, member in
                presentChangeAdminAlert.accept(member)
            }
            .disposed(by: disposeBag)
        
        input.changeAdminTrigger
            .withUnretained(self)
            .map { _, ownerID in
                let channelRequest = ChannelRequestDTO(
                    channelId: self.channelID
                )
                let changeAdminRequest = ChangeAdminRequestDTO(
                    owner_id: ownerID
                )
                return (channelRequest, changeAdminRequest)
            }
            .flatMap { request in
                let (path, body) = request
                return self.useCase.changeAdmin(
                    path: path,
                    body: body
                )
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    completeChangeAdmin.accept(value.owner_id)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            memberList: memberList.asDriver(),
            presentDisableAlert: presentDisableAlert.asSignal(),
            presentChangeAdminAlert: presentChangeAdminAlert.asSignal(),
            completeChangeAdmin: completeChangeAdmin.asSignal()
        )
    }
}
