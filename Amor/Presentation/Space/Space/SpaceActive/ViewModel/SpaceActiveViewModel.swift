//
//  SpaceActiveViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SpaceActiveViewModel: BaseViewModel {
    private let useCase: HomeUseCase
    private let disposeBag = DisposeBag()
    private let viewType: SpaceActiveViewType

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let nameTextFieldText: ControlProperty<String>
        let descriptionTextFieldText: ControlProperty<String>
        let image: BehaviorRelay<Data>
        let buttonTap: ControlEvent<Void>
    }

    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let spaceName: BehaviorRelay<String>
        let spaceDescription: BehaviorRelay<String?>
        let spaceImage: BehaviorRelay<String?>
        let confirmButtonEnabled: Observable<Bool>
    }

    init(viewType: SpaceActiveViewType, useCase: HomeUseCase) {
        self.viewType = viewType
        self.useCase = useCase
    }

    func transform(_ input: Input) -> Output {
        let viewTypeRelay = BehaviorRelay<SpaceActiveViewType>(value: self.viewType)
        let navigationTitleRelay = BehaviorRelay<String>(value: "")
        let spaceNameRelay = BehaviorRelay<String>(value: "")
        let spaceDescriptionRelay = BehaviorRelay<String?>(value: nil)
        let spaceImageRelay = BehaviorRelay<String?>(value: nil)

        viewTypeRelay
            .bind(with: self) { owner, viewType in
                navigationTitleRelay.accept(viewType.navigationTitle)
                if case .edit(let value) = viewType {
                    spaceNameRelay.accept(value.name)
                    spaceDescriptionRelay.accept(value.description)
                    spaceImageRelay.accept(value.coverImage)
                    print(value.coverImage)
                }
            }
            .disposed(by: disposeBag)

        input.viewDidLoadTrigger
            .map { self.viewType }
            .bind(to: viewTypeRelay)
            .disposed(by: disposeBag)
        
        
        let confirmButtonEnabled = input.nameTextFieldText
            .map { $0.count > 0 && $0.count < 30 }
        
        input.buttonTap
            .withLatestFrom(Observable.combineLatest(
                input.nameTextFieldText.map { $0.isEmpty ? spaceNameRelay.value : $0 },
                input.descriptionTextFieldText.map { ($0.isEmpty ? spaceDescriptionRelay.value : $0) ?? "" },
                input.image
            ))
            .map {
                let imageName = $0.2 == Data() ? "" : "coverImage/\(Date().toServerDateStr())"
                
                let request = SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
                let body = EditSpaceRequestDTO(name: $0.0, description: $0.1, image: $0.2, imageName: imageName)
                return (request, body)
            }
            .flatMap { self.useCase.editSpcaeInfo(request: $0.0, body: $0.1) }
            .bind(with: self) { owner, result in
                print(result)
            }
            .disposed(by: disposeBag)
            

        return Output(
            navigationTitle: navigationTitleRelay,
            spaceName: spaceNameRelay,
            spaceDescription: spaceDescriptionRelay,
            spaceImage: spaceImageRelay,
            confirmButtonEnabled: confirmButtonEnabled
        )
    }
}
