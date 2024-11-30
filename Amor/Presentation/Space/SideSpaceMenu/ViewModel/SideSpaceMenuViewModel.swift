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
    private let useCase: HomeUseCase
    private var ownerSpaces = [SpaceSimpleInfo]()
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: BehaviorSubject<Void>
        let selectedItem: BehaviorRelay<SpaceSimpleInfo?>
    }
    
    struct Output {
        let mySpaces: BehaviorSubject<[SpaceSimpleInfo]>
    }
    
    func transform(_ input: Input) -> Output {
        let mySpaces = BehaviorSubject<[SpaceSimpleInfo]>(value: [])
        let changeIndex = PublishSubject<Int>()
        
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
        
        input.selectedItem
            .debug("입력됨")
            .bind(with: self) { owner, value in
                print(#function, value)
                guard let selectedItem = value else { return }
                
                if let index = owner.ownerSpaces.firstIndex(where: { $0.workspace_id == selectedItem.workspace_id }) {
                    owner.ownerSpaces[index] = selectedItem
                    mySpaces.onNext(owner.ownerSpaces)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(mySpaces: mySpaces)
    }
}
