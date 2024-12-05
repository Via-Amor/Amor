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
        let changedSpaceOwner: PublishSubject<SpaceMember>
    }
    
    struct Output {
        let disabledChangeSpaceOwner: PublishSubject<Void>
        let spaceMember: BehaviorSubject<[SpaceMember]>
        let changeOwnerComplete: PublishSubject<SpaceSimpleInfo>
    }
    
    func transform(_ input: Input) -> Output {
        let disabledChangeSpaceOwner = PublishSubject<Void>()
        let spaceMember = BehaviorSubject<[SpaceMember]>(value: [])
        let changeOwnerComplete = PublishSubject<SpaceSimpleInfo>()
        
        input.trigger
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap { self.useCase.getSpaceMembers(request: $0)}
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    let members = success.filter { $0.user_id != UserDefaultsStorage.userId  }
                    if members.isEmpty {
                        disabledChangeSpaceOwner.onNext(())
                    } else {
                        spaceMember.onNext(members)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.changedSpaceOwner
            .map { (SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId),  ChangeSpaceOwnerRequestDTO(owner_id: $0.user_id)) }
            .flatMap { self.useCase.changeSpaceOwner(request: $0.0, body: $0.1)}
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changeOwnerComplete.onNext(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(disabledChangeSpaceOwner: disabledChangeSpaceOwner, spaceMember: spaceMember, changeOwnerComplete: changeOwnerComplete)
    }
}
