//
//  DMViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMListViewModel: BaseViewModel {
    private let userUseCase: UserUseCase
    private let spaceUseCase: SpaceUseCase
    private let dmUseCase: DMUseCase
    private let chatUseCase: ChatUseCase
    private let disposeBag = DisposeBag()

    init(
        userUseCase: UserUseCase,
        spaceUseCase: SpaceUseCase,
        dmUseCase: DMUseCase,
        chatUseCase: ChatUseCase
    ) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.dmUseCase = dmUseCase
        self.chatUseCase = chatUseCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let fromProfileToDM: PublishRelay<String>
    }
    
    struct Output {
        let spaceImage: Driver<String?>
        let profileImage: Driver<String?>
        let spaceMemberArray: Driver<[SpaceMember]>
        let isSpaceMemberEmpty: Signal<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let profileImage = BehaviorRelay<String?>(value: nil)
        let spaceMemberArray = BehaviorRelay<[SpaceMember]>(value: [])
        let isSpaceMemberEmpty = PublishRelay<Bool>()

        let profile = input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.userUseCase.getMyProfile()
            }
        
        let space = input.viewWillAppearTrigger
            .withUnretained(self)
            .map { _ in
                let request = SpaceRequestDTO(
                    workspace_id: UserDefaultsStorage.spaceId
                )
                return request
            }
            .flatMap { request in
                self.spaceUseCase.getSpaceInfo(request: request)
            }
        
        let dmList = input.viewWillAppearTrigger
            .map {
                DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
            }
            .withUnretained(self)
            .flatMap { (self, request ) in
                self.dmUseCase.fetchDMRoomList(request: request)
            }
        

        
        Observable.zip(profile, space)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, value in
                switch value {
                case (.success(let profile), .success(let space)):
                    profileImage.accept(profile.profileImage)

                    spaceImage.accept(space.coverImage)
                    let spaceMember = space.workspaceMembers.filter {
                        $0.user_id != UserDefaultsStorage.userId
                    }
                    isSpaceMemberEmpty.accept(spaceMember.isEmpty)
                    spaceMemberArray.accept(spaceMember)
                default:
                    print("DM 리스트 조회 오류")
                    break
                }
             
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            spaceImage: spaceImage.asDriver(),
            profileImage: profileImage.asDriver(),
            spaceMemberArray: spaceMemberArray.asDriver(),
            isSpaceMemberEmpty: isSpaceMemberEmpty.asSignal()
        )
    }
}
