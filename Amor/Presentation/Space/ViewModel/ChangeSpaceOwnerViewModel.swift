//
//  ChangeSpaceOwnerViewModel.swift
//  Amor
//
//  Created by 김상규 on 12/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChangeSpaceOwnerViewModel: BaseViewModel {
    let disposeBag = DisposeBag()
    let useCase: SpaceUseCase
    
    init(useCase: SpaceUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: BehaviorRelay<Void>
    }
    
    struct Output {
        let disabledChangeSpaceOwner: PublishSubject<Void>
        let spaceMember: BehaviorSubject<[SpaceMember]>
    }
    
    func transform(_ input: Input) -> Output {
        let disabledChangeSpaceOwner = PublishSubject<Void>()
        let spaceMember = BehaviorSubject<[SpaceMember]>(value: [])
        
        input.trigger
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap { self.useCase.getSpaceMembers(request: $0)}
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    if success.count == 1 {
                        disabledChangeSpaceOwner.onNext(())
                    } else {
                        spaceMember.onNext(success)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(disabledChangeSpaceOwner: disabledChangeSpaceOwner, spaceMember: spaceMember)
    }
}
