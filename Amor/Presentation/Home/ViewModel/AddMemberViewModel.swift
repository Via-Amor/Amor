//
//  AddMemberViewModel.swift
//  Amor
//
//  Created by 김상규 on 12/3/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddMemberViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    let useCase: SpaceUseCase
    
    init(useCase: SpaceUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let emailText: ControlProperty<String>
        let addButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let addButtonEnabled: Observable<Bool>
        let addComplete: PublishRelay<Void>
    }

    func transform(_ input: Input) -> Output {
        let addComplete = PublishRelay<Void>()
        
        let addButtonEnabled = input.emailText
            .map { $0.count > 0 }
            .share(replay: 1)
        
        input.addButtonClicked
            .withLatestFrom(input.emailText)
            .map {
                return (SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId) , AddMemberRequestDTO(email: $0))
            }
            .flatMap { request in
                self.useCase.addMember(request: request.0, body: request.1)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    addComplete.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(addButtonEnabled: addButtonEnabled, addComplete: addComplete)
    }
}
