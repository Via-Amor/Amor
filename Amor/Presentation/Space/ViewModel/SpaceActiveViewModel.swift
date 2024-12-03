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
    private let useCase: SpaceUseCase
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

    init(viewType: SpaceActiveViewType, useCase: SpaceUseCase) {
        self.viewType = viewType
        self.useCase = useCase
    }

    func transform(_ input: Input) -> Output {
        let viewTypeRelay = BehaviorRelay<SpaceActiveViewType>(value: self.viewType)
        let navigationTitle = BehaviorRelay<String>(value: "")
        let spaceName = BehaviorRelay<String>(value: "")
        let spaceDescription = BehaviorRelay<String?>(value: nil)
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let actionComplete = PublishRelay<SpaceSimpleInfo>()

        input.viewDidLoadTrigger
            .map { self.viewType }
            .bind(to: viewTypeRelay)
            .disposed(by: disposeBag)
        
        viewTypeRelay
            .bind(with: self) { owner, viewType in
                navigationTitle.accept(viewType.navigationTitle)
                switch viewType {
                case .create:
                    spaceImage.accept(nil)
                    
                case .edit(let value):
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
        
        let confirmButtonEnabled = Observable.combineLatest(input.nameTextFieldText, input.descriptionTextFieldText, input.imageName)
            .map { (name, description, imageName) -> Bool in
                if !imageName.isEmpty {
                    return true
                }
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
            .flatMap { (name, description, image, imageName) in
                let body = EditSpaceRequestDTO(name: name, description: description, image: image, imageName: imageName)
                
                switch self.viewType {
                case .create:
                    return self.useCase.addSpace(body: body)
                case .edit:
                    let request = SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
                    return self.useCase.editSpaceInfo(request: request, body: body)
                }
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    actionComplete.accept(success)
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
            editComplete: actionComplete
        )
    }
}
