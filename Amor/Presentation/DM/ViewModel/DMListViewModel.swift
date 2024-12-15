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
    private let disposeBag = DisposeBag()
    
    init(
        userUseCase: UserUseCase,
        spaceUseCase: SpaceUseCase,
        dmUseCase: DMUseCase
    ) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.dmUseCase = dmUseCase
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let memberProfileClicked: ControlEvent<SpaceMember>
        let dmListClicked: ControlEvent<DMListContent>
    }
    
    struct Output {
        let spaceImage: Driver<String?>
        let profileImage: Driver<String?>
        let spaceMemberArray: Driver<[SpaceMember]>
        let isSpaceMemberEmpty: Signal<Bool>
        let presentDmList: Driver<[DMListContent]>
        let presentDMChat: Signal<DMRoomInfo>
    }
    
    func transform(_ input: Input) -> Output {
        let spaceImage = BehaviorRelay<String?>(value: nil)
        let profileImage = BehaviorRelay<String?>(value: nil)
        let spaceMemberArray = BehaviorRelay<[SpaceMember]>(value: [])
        let isSpaceMemberEmpty = PublishRelay<Bool>()
        let presentDmList = BehaviorRelay<[DMListContent]>(value: [])
        let presentDMChat = PublishRelay<DMRoomInfo>()

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
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.dmUseCase.fetchDMChatListWithCount()
            }
            .bind(with: self) { owner, dmList in
                presentDmList.accept(dmList)
            }
            .disposed(by: disposeBag)
        
       
        
        input.memberProfileClicked
            .map { member in
                let request = DMRoomRequestDTO(
                    workspace_id: UserDefaultsStorage.spaceId
                )
                let body = DMRoomRequestDTOBody(
                    opponent_id: member.user_id
                )
                return (request, body)
            }
            .withUnretained(self)
            .flatMap { owner, value in
                owner.dmUseCase.makeDMRoom(
                    request: value.0,
                    body: value.1
                )
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let value):
                    presentDMChat.accept(value.toDomain())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.dmListClicked
            .map { dmListContent in
                dmListContent.toDMRoomInfo()
            }
            .bind(with: self) { owner, dmRoomInfo in
                presentDMChat.accept(dmRoomInfo)
            }
            .disposed(by: disposeBag)
        
        return Output(
            spaceImage: spaceImage.asDriver(),
            profileImage: profileImage.asDriver(),
            spaceMemberArray: spaceMemberArray.asDriver(),
            isSpaceMemberEmpty: isSpaceMemberEmpty.asSignal(),
            presentDmList: presentDmList.asDriver(),
            presentDMChat: presentDMChat.asSignal()
        )
    }
}
