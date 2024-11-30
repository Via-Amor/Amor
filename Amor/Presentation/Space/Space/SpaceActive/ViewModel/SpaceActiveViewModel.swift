//
//  SpaceActiveViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SpaceActiveViewModel: BaseViewModel {
    private let useCase: HomeUseCase
    private let disposeBag = DisposeBag()
    private let viewType: SpaceActiveViewType
    private var currentImage: UIImage?

    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let nameTextFieldText: ControlProperty<String>
        let descriptionTextFieldText: ControlProperty<String?>
        let image: BehaviorRelay<UIImage?>
        let imageName: BehaviorRelay<String>
        let buttonTap: ControlEvent<Void>
    }

    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let spaceName: BehaviorRelay<String>
        let spaceDescription: BehaviorRelay<String?>
        let spaceImage: BehaviorRelay<String?>
        let confirmButtonEnabled: Observable<Bool>
        let editComplete: PublishRelay<SpaceSimpleInfo>
    }

    init(viewType: SpaceActiveViewType, useCase: HomeUseCase) {
        self.viewType = viewType
        self.useCase = useCase
    }

    func transform(_ input: Input) -> Output {
        let viewTypeRelay = BehaviorRelay<SpaceActiveViewType>(value: self.viewType)
        let navigationTitle = BehaviorRelay<String>(value: "")
        let spaceName = BehaviorRelay<String>(value: "")
        let spaceDescription = BehaviorRelay<String?>(value: nil)
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let editComplete = PublishRelay<SpaceSimpleInfo>()

        input.viewDidLoadTrigger
            .map { self.viewType }
            .bind(to: viewTypeRelay)
            .disposed(by: disposeBag)
        
        viewTypeRelay
            .bind(with: self) { owner, viewType in
                navigationTitle.accept(viewType.navigationTitle)
                if case .edit(let value) = viewType {
                    spaceName.accept(value.name)
                    spaceDescription.accept(value.description)
                    spaceImage.accept(value.coverImage)
                }
            }
            .disposed(by: disposeBag)
        
        spaceName
            .bind(to: input.nameTextFieldText)
            .disposed(by: disposeBag)
        
        spaceDescription
            .bind(to: input.descriptionTextFieldText)
            .disposed(by: disposeBag)
        
        let confirmButtonEnabled = Observable.combineLatest(input.nameTextFieldText, input.descriptionTextFieldText)
            .map { (name, description) -> Bool in
                if description != spaceDescription.value ?? "" {
                    return true
                } else {
                    if name != spaceName.value {
                        return name.count > 0 && name.count < 30
                    } else {
                        return false
                    }
                }
            }
            .share(replay: 1)
        
        input.buttonTap
            .withLatestFrom(Observable.combineLatest(
                input.nameTextFieldText.map {
                   return $0.isEmpty ? spaceName.value : $0
                },
                input.descriptionTextFieldText,
                input.image.map { (value) -> Data? in
                    guard let image = value, let data = image.jpegData(compressionQuality: 0.5) else { return nil }
                    return data
                },
                input.imageName
            ))
            .map {
                let request = SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
                let body = EditSpaceRequestDTO(name: $0.0, description: $0.1, image: $0.2, imageName: $0.3)
                
                return (request, body)
            }
            .flatMap { self.useCase.editSpcaeInfo(request: $0.0, body: $0.1) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    editComplete.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            

        return Output(
            navigationTitle: navigationTitle,
            spaceName: spaceName,
            spaceDescription: spaceDescription,
            spaceImage: spaceImage,
            confirmButtonEnabled: confirmButtonEnabled,
            editComplete: editComplete
        )
    }
}
