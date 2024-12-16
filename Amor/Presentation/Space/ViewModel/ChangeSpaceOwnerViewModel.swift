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
        let changedSpaceOwner: PublishRelay<SpaceMember>
    }
    
    struct Output {
        let disabledChangeSpaceOwner: PublishRelay<Void>
        let spaceMember: BehaviorRelay<[SpaceMember]>
        let changeOwnerComplete: PublishRelay<SpaceSimpleInfo>
    }
    
    func transform(_ input: Input) -> Output {
        let disabledChangeSpaceOwner = PublishRelay<Void>()
        let spaceMember = BehaviorRelay<[SpaceMember]>(value: [])
        let changeOwnerComplete = PublishRelay<SpaceSimpleInfo>()
        
        input.trigger
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap { self.useCase.getSpaceMembers(request: $0)}
            .bind(with: self) { owner, members in
                if members.isEmpty {
                    disabledChangeSpaceOwner.accept(())
                } else {
                    spaceMember.accept(members)
                }
            }
            .disposed(by: disposeBag)
        
        input.changedSpaceOwner
            .map { (SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId),  ChangeSpaceOwnerRequestDTO(owner_id: $0.user_id)) }
            .flatMap { self.useCase.changeSpaceOwner(request: $0.0, body: $0.1)}
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    changeOwnerComplete.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        
        return Output(disabledChangeSpaceOwner: disabledChangeSpaceOwner, spaceMember: spaceMember, changeOwnerComplete: changeOwnerComplete)
    }
}
