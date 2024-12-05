//
//  DMViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: DMUseCase
    
    init(useCase: DMUseCase) {
        self.useCase = useCase
    }
    
    func transform(_ input: Input) -> Output {
        let getSpaceInfo = PublishSubject<Void>()
        let spaceImage = PublishSubject<String?>()
        let myImage = PublishSubject<String?>()
        let spaceMemberArray = BehaviorSubject<[SpaceMember]>(value: [])
        let dmRoomArray = BehaviorSubject<[DMRoom]>(value: [])
        let getSpaceMembers = PublishSubject<Void>()
        let getDms = PublishSubject<Void>()
        let isEmpty = PublishRelay<Bool>()
        let fetchEnd = PublishRelay<Void>()
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in self.useCase.getMyProfile() }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    getSpaceInfo.onNext(())
                    myImage.onNext(success.profileImage)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
            
        getSpaceInfo
            .map { SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap { self.useCase.getSpaceInfo(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    spaceImage.onNext(success.coverImage)
                    getSpaceMembers.onNext(())
                    getDms.onNext(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getSpaceMembers
            .map { SpaceMembersRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap{ self.useCase.getSpaceMembers(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let users):
                    print("내 아이디", UserDefaultsStorage.userId)
                    var spaceMembers = users.filter({ $0.user_id != UserDefaultsStorage.userId })
                    if spaceMembers.isEmpty {
                        spaceMembers = []
                    }
                    spaceMemberArray.onNext(spaceMembers)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getDms
            .map { DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap({ self.useCase.getDMRooms(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dmRooms):
                    if dmRooms.isEmpty {
                        let array: [DMRoom] = []
                        dmRoomArray.onNext(array)
                    } else {
                        dmRoomArray.onNext(dmRooms)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(spaceMemberArray, dmRoomArray)
            .bind(with: self) { owner, value in
                isEmpty.accept(value.0.isEmpty && value.1.isEmpty)
                fetchEnd.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(spaceImage: spaceImage, myImage: myImage, spaceMemberArray: spaceMemberArray, dmRoomArray: dmRoomArray, isEmpty: isEmpty, fetchEnd: fetchEnd)
    }
}

extension DMViewModel {
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let spaceImage: PublishSubject<String?>
        let myImage: PublishSubject<String?>
        let spaceMemberArray: BehaviorSubject<[SpaceMember]>
        let dmRoomArray: BehaviorSubject<[DMRoom]>
        let isEmpty: PublishRelay<Bool>
        let fetchEnd: PublishRelay<Void>
    }
}
