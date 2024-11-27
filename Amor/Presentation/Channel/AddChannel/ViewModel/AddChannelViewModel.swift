//
//  AddChannelViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddChannelViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    let useCase: HomeUseCase
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let channelNameText: ControlProperty<String>
        let channelSubscriptionText: ControlProperty<String>
        let addChannelButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let addChannelButtonEnabled: Observable<Bool>
        let addChannelComplete: PublishSubject<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let addChannelComplete = PublishSubject<Void>()
        let addChannelButtonEnabled = input.channelNameText
            .map { $0.count > 0 && $0.count < 30 }
            .share(replay: 1)
        
        input.addChannelButtonClicked
            .withLatestFrom(Observable.combineLatest(input.channelNameText, input.channelSubscriptionText))
//            .bind(with: self) { owner, value in
//                print(value.0)
//                print(value.1)
//                addChannelComplete.onNext(())
//            }
//            .disposed(by: disposeBag)
            .map { name, description in
                let path = ChannelRequestDTO()
                let query = AddChannelRequestDTO(name: name, description: description)
                return (path, query)
            }
            .flatMap { path, query in
                self.useCase.addChannel(path: path, body: query)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                    addChannelComplete.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(addChannelButtonEnabled: addChannelButtonEnabled, addChannelComplete: addChannelComplete)
    }
}
