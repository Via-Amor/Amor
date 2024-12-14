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
    private let useCase: ChannelUseCase
    private let disposeBag = DisposeBag()
    
    init(
        editChannel: EditChannel,
        useCase: ChannelUseCase
    ) {
        self.channelInfo = editChannel
        self.useCase = useCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        let completeButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let presentChannelInfo: Signal<EditChannel>
        let completeButtonActive: Driver<Bool>
        let editComplete: Signal<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let presentChannelInfo = PublishRelay<EditChannel>()
        let completeButtonActive = BehaviorRelay<Bool>(value: true)
        let editComplete = PublishRelay<Void>()
        
        input.viewWillAppearTrigger
            .bind(with: self) { owner, _ in
                presentChannelInfo.accept(owner.channelInfo)
            }
            .disposed(by: disposeBag)
        
        input.nameText
        .map { value in
            value.count > 0 && value.count <= 30
        }
        .bind(to: completeButtonActive)
        .disposed(by: disposeBag)
        
        input.completeButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(
                Observable.combineLatest(
                    input.nameText,
                    input.descriptionText,
                    presentChannelInfo
                )
            )
            .map { (name, description, channel) in
                let path = ChannelRequestDTO(channelId: channel.channelID)
                let body = EditChannelRequestDTO(name: name, description: description)
                return (path, body)
            }
            .withUnretained(self)
            .flatMap { owner, value in
                owner.useCase.editChannel(path: value.0, body: value.1)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    editComplete.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            

        return Output(
            presentChannelInfo: presentChannelInfo.asSignal(),
            completeButtonActive: completeButtonActive.asDriver(),
            editComplete: editComplete.asSignal()
        )
    }
}
