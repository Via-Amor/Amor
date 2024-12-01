//
//  SideSpaceMenuViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import RxSwift
import RxCocoa

final class SideSpaceMenuViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: SpaceUseCase
    private var ownerSpaces = [SpaceSimpleInfo]()
    
    init(useCase: SpaceUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: BehaviorSubject<Void>
        let space: PublishRelay<SpaceSimpleInfo?>
    }
    
    struct Output {
        let mySpaces: BehaviorSubject<[SpaceSimpleInfo]>
    }
    
    func transform(_ input: Input) -> Output {
        let mySpaces = BehaviorSubject<[SpaceSimpleInfo]>(value: [])
        
        input.trigger
            .flatMap { self.useCase.getAllMySpaces() }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    mySpaces.onNext(value)
                    owner.ownerSpaces = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.space
            .bind(with: self) { owner, value in
                guard let space = value else { return }
                
                if let index = owner.ownerSpaces.firstIndex(where: { $0.workspace_id == space.workspace_id }) {
                    owner.ownerSpaces[index] = space
                    mySpaces.onNext(owner.ownerSpaces)
                } else {
                    owner.ownerSpaces.insert(space, at: 0)
                    mySpaces.onNext(owner.ownerSpaces)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(mySpaces: mySpaces)
    }
}
