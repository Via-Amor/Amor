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
        let trigger: BehaviorRelay<Void>
        let changedSpace: PublishRelay<SpaceSimpleInfo?>
        let deleteSpaceId: PublishRelay<String>
        let leavedSpaceId: PublishRelay<String>
    }
    
    struct Output {
        let mySpaces: BehaviorRelay<[SpaceSimpleInfo]>
        let afterAction: PublishRelay<SpaceSimpleInfo>
        let showEmptyView: PublishRelay<Bool>
        let isEmptyMySpace: PublishRelay<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let mySpaces = BehaviorRelay<[SpaceSimpleInfo]>(value: [])
        let fetchSpaces = PublishSubject<Void>()
        let afterAction = PublishRelay<SpaceSimpleInfo>()
        let isEmptyMySpace = PublishRelay<Void>()
        let showEmptyView = PublishRelay<Bool>()
        
        input.trigger
            .flatMap { self.useCase.getAllMySpaces() }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    if !value.isEmpty {
                        mySpaces.accept(value)
                    }
                    showEmptyView.accept(value.isEmpty)
                    owner.ownerSpaces = value
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.changedSpace
            .bind(with: self) { owner, value in
                guard let space = value else { return }
                
                if let index = owner.ownerSpaces.firstIndex(where: { $0.workspace_id == space.workspace_id }) {
                    owner.ownerSpaces[index] = space
                    mySpaces.accept(owner.ownerSpaces)
                } else {
                    owner.ownerSpaces.insert(space, at: 0)
                    mySpaces.accept(owner.ownerSpaces)
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteSpaceId
            .map {
                SpaceRequestDTO(workspace_id: $0)
            }
            .flatMap {
                self.useCase.removeSpace(request: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success:
                    fetchSpaces.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.leavedSpaceId
            .map {
                SpaceRequestDTO(workspace_id: $0)
            }
            .flatMap {
                self.useCase.leaveSpace(request: $0)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    guard let recentSpace = value.sorted(by: {
                        $0.createdAt.toServerDate() > $1.createdAt.toServerDate()
                    }).first else {
                        UserDefaultsStorage.spaceId = ""
                        isEmptyMySpace.accept(())
                        return
                    }
                    
                    UserDefaultsStorage.spaceId = recentSpace.workspace_id
                    afterAction.accept(recentSpace)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        fetchSpaces
            .flatMap {
                self.useCase.getAllMySpaces()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    guard let recentSpace = value.sorted(by: {
                        $0.createdAt.toServerDate() > $1.createdAt.toServerDate()
                    }).first else {
                        UserDefaultsStorage.spaceId = ""
                        isEmptyMySpace.accept(())
                        return
                    }
                    
                    UserDefaultsStorage.spaceId = recentSpace.workspace_id
                    afterAction.accept(recentSpace)
                case .failure(let error):
                    switch error {
                    case .commonError:
                        print(error)
                    default:
                        print("채널 소유자")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(mySpaces: mySpaces, afterAction: afterAction, showEmptyView: showEmptyView, isEmptyMySpace:  isEmptyMySpace)
    }
}
