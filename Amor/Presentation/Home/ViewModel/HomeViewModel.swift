//
//  HomeViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

final class HomeViewModel: BaseViewModel {
    private let userUseCase: UserUseCase
    private let spaceUseCase: SpaceUseCase
    private let channelUseCase: ChannelUseCase
    private let dmUseCase: DMUseCase
    
    private var sections: [HomeSectionModel] = []
    private var myChannels: [HomeSectionItem] = []
    private var dmRooms: [HomeSectionItem] = []
    private let disposeBag = DisposeBag()
    
    init(
        userUseCase: UserUseCase,
        spaceUseCase: SpaceUseCase,
        channelUseCase: ChannelUseCase,
        dmUseCase: DMUseCase
    ) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.channelUseCase = channelUseCase
        self.dmUseCase = dmUseCase
    }
    
    struct Input {
        let trigger: PublishRelay<Void>
        let updateChannelTrigger: PublishRelay<Void>
        let updateChannelValueTrigger: PublishRelay<[Channel]>
        let toggleSection: PublishRelay<Int>
        let fetchChannel: PublishSubject<Void>
        let fetchHome: PublishRelay<Void>
        let showToast: PublishSubject<String>
    }
    
    struct Output {
        let myProfileImage: PublishSubject<String?>
        let noSpace: PublishSubject<Void>
        let spaceInfo: BehaviorRelay<SpaceInfo?>
        let dataSource: PublishSubject<[HomeSectionModel]>
        let fetchedHome: PublishSubject<Void>
        let backLoginView: PublishSubject<Void>
        let toastMessage: PublishRelay<String>
    }
    
    func transform(_ input: Input) -> Output {
        let backLoginView = PublishSubject<Void>()
        let noSpace = PublishSubject<Void>()
        let myProfileImage = PublishSubject<String?>()
        
        let getSpaceInfo = PublishSubject<Void>()
        let getMyChannels = PublishSubject<Void>()
        let getDMRooms = PublishSubject<Void>()
        
        let spaceInfo = BehaviorRelay<SpaceInfo?>(value: nil)
        let myChannelArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dmRoomArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dataSource = PublishSubject<[HomeSectionModel]>()
        
        let toastMessage = PublishRelay<String>()
        let fetchedHome = PublishSubject<Void>()
        
        input.trigger
            .flatMap {
                self.userUseCase.getMyProfile()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myProfile):
                    myProfileImage.onNext(myProfile.profileImage)
                    if UserDefaultsStorage.spaceId.isEmpty {
                        noSpace.onNext(())
                    } else {
                        getSpaceInfo.onNext(())
                        getMyChannels.onNext(())
                        getDMRooms.onNext(())
                    }
                    
                case .failure:
                    backLoginView.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        // 스페이스 정보
        getSpaceInfo
            .map { SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap({ self.spaceUseCase.getSpaceInfo(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    spaceInfo.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 채널 정보
        getMyChannels
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.channelUseCase.fetchHomeChannelChatListWithCount()
            }
            .bind(with: self) { owner, channelList in
                var channelSection = channelList
                channelSection.append(HomeSectionItem.add(HomeAddText.channel.rawValue))
                myChannelArray.onNext(channelSection)
                owner.myChannels = channelSection
            }
            .disposed(by: disposeBag)
        
        // DM 정보
        getDMRooms
            .withUnretained(self)
            .flatMap { (owner, _) in
                owner.dmUseCase.fetchHomeDMChatListWithCount()
            }
            .bind(with: self) { owner, dmRoomList in
                var dmSection = dmRoomList
                dmSection.append(HomeSectionItem.add(HomeAddText.dm.rawValue))
                dmRoomArray.onNext(dmSection)
                owner.dmRooms = dmSection
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(myChannelArray, dmRoomArray)
            .bind(with: self) { owner, value in
                let array = [
                    HomeSectionModel(
                        section: 0, header: HomeSectionHeader.channel.rawValue, isOpen: true, items: value.0
                    ),
                    HomeSectionModel(
                        section: 1, header: HomeSectionHeader.dm.rawValue, isOpen: true, items: value.1
                    ),
                    HomeSectionModel(
                        section: 2, header: HomeSectionHeader.member.rawValue, isOpen: false, items: [HomeSectionModel.Item.add(HomeAddText.member.rawValue)])
                ]
                dataSource.onNext(array)
                owner.sections = array
            }
            .disposed(by: disposeBag)
        
        input.toggleSection
            .bind(with: self) { owner, value in
                owner.sections[value].isOpen.toggle()
                
                if !owner.sections[value].isOpen {
                    switch value {
                    case 0, 1:
                        owner.sections[value].items = []
                    default:
                        break
                    }
                } else {
                    switch value {
                    case 0:
                        owner.sections[value].items = owner.myChannels
                    case 1:
                        owner.sections[value].items = owner.dmRooms
                    default:
                        break
                    }
                }
                
                dataSource.onNext(owner.sections)
            }
            .disposed(by: disposeBag)
        
        // 사이드 메뉴에서 워크스페이스가 추가되었을 때
        // 1. 워크스페이스가 변경되면서 홈화면 구성요소 재조회 (전체 재조회)
        input.fetchHome
            .bind(with: self) { owner, _ in
                input.trigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 채널 설정에서 업데이트 값이 발생헀을 때 - 채널 삭제 등
        // 2. 채널에 대한 값만 재조회
        input.updateChannelTrigger
            .bind(with: self) { owner, _ in
                getMyChannels.onNext(())
            }
            .disposed(by: disposeBag)
        
        // 사이드 메뉴에서 채널 추가 되었을 때
        // 2. 채널에 대한 값만 재조회 -> 위와 동일
        input.fetchChannel
            .bind(to: getMyChannels)
            .disposed(by: disposeBag)
        
        // 채널 설정에서 채널 값을 준 경우 - 채널 나가기 등
        // 3. 채널에 대한 값을 외부에서 받아서 섹션을 업데이트
        //        input.updateChannelValueTrigger
        //            .map {
        //                var channelList = $0.map {
        //                    HomeSectionModel.Item.myChannelItem($0)
        //                }
        //                channelList.append(
        //                    HomeSectionModel.Item.add(HomeAddText.channel.rawValue)
        //                )
        //                return channelList
        //            }
        //            .bind(with: self) { owner, sectionItem in
        //                myChannelArray.onNext(sectionItem)
        //            }
        //            .disposed(by: disposeBag)
        
        input.showToast
            .bind(with: self) { owner, value in
                toastMessage.accept(value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            myProfileImage: myProfileImage,
            noSpace: noSpace,
            spaceInfo: spaceInfo,
            dataSource: dataSource,
            fetchedHome: fetchedHome,
            backLoginView: backLoginView,
            toastMessage: toastMessage
        )
    }
}

extension HomeViewModel {
    enum HomeAddText: String {
        case channel = "채널 추가"
        case dm = "새메세지 시작"
        case member = "팀원 추가"
    }
    
    enum HomeSectionHeader: String {
        case channel = "채널"
        case dm = "다이렉트 메세지"
        case member = ""
    }
    
}
