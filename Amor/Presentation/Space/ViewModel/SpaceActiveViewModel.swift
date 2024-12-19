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

    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let nameTextFieldText: ControlProperty<String>
        let descriptionTextFieldText: ControlProperty<String?>
        let image: BehaviorRelay<UIImage?>
        let imageName: BehaviorRelay<String?>
        let buttonTap: ControlEvent<Void>
    }
    
    struct Output {
        let navigationTitle: BehaviorRelay<String>
        let spaceName: BehaviorRelay<String>
        let spaceDescription: BehaviorRelay<String?>
        let spaceImage: BehaviorRelay<String?>
        let confirmButtonEnabled: Observable<Bool>
        let createComplete: PublishRelay<SpaceSimpleInfo>
        let showToast: PublishRelay<String>
    }

    init(viewType: SpaceActiveViewType, useCase: SpaceUseCase) {
        self.viewType = viewType
        self.useCase = useCase
    }

    func transform(_ input: Input) -> Output {
        let viewType = BehaviorRelay<SpaceActiveViewType>(value: self.viewType)
        let navigationTitle = BehaviorRelay<String>(value: "")
        let spaceName = BehaviorRelay<String>(value: "")
        let spaceDescription = BehaviorRelay<String?>(value: nil)
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let createComplete = PublishRelay<SpaceSimpleInfo>()
        let showToast = PublishRelay<String>()

        input.viewWillAppearTrigger
            .map { self.viewType }
            .bind(to: viewType)
            .disposed(by: disposeBag)
        
        viewType
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
        
        let confirmButtonEnabled = Observable.combineLatest(input.nameTextFieldText, input.imageName)
            .map { (name, imageName) -> Bool in
                return name.count > 0 && name.count < 30
            }
        
        input.buttonTap
            .withLatestFrom(Observable.combineLatest(
                input.nameTextFieldText,
                input.descriptionTextFieldText,
                input.image.map { (value) -> Data? in
                    guard let image = value, let data = image.jpegData(compressionQuality: 0.5) else { return nil }
                    return data
                },
                input.imageName
            ))
            .map { (name, description, image, imageName) in
                return EditSpaceRequestDTO(
                    name: name,
                    description: description,
                    image: image,
                    imageName: imageName
                )
            }
            .flatMap { body in
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
                    createComplete.accept(success)
                case .failure:
                    
                    // 이미지가 존재하지 않은 경우 토스트 메세지 표시
                    showToast.accept("라운지 이미지를 등록해주세요.")
                }
            }
            .disposed(by: disposeBag)
            

        return Output(
            navigationTitle: navigationTitle,
            spaceName: spaceName,
            spaceDescription: spaceDescription,
            spaceImage: spaceImage,
            confirmButtonEnabled: confirmButtonEnabled,
            createComplete: createComplete,
            showToast: showToast
        )
    }
}
