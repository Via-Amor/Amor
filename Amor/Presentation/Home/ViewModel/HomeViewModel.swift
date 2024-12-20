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
    private let homeUseCase: HomeUseCase
    private let disposeBag = DisposeBag()
    
    private var sections: [HomeSectionModel] = []
    private var channelSectionList: [HomeSectionItem] = []
    private var dmRoomSectionList: [HomeSectionItem] = []
    
    init(
        userUseCase: UserUseCase,
        spaceUseCase: SpaceUseCase,
        homeUseCase: HomeUseCase
    ) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.homeUseCase = homeUseCase
    }
    
    struct Input {
        let fetchHomeDefaultTrigger: BehaviorRelay<Void>
        let updateChannelTrigger: PublishRelay<Void>
        let updateChannelValueTrigger: PublishRelay<[Channel]>
        let toggleSection: PublishRelay<Int>
    }
    
    struct Output {
        let myProfileImage: PublishRelay<String?>
        let noSpace: PublishRelay<Void>
        let spaceInfo: BehaviorRelay<SpaceInfo?>
        let dataSource: PublishRelay<[HomeSectionModel]>
        let backLoginView: PublishRelay<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let backLoginView = PublishRelay<Void>()
        let noSpace = PublishRelay<Void>()
        let myProfileImage = PublishRelay<String?>()

        let fetchSpaceInfo = PublishRelay<Void>()
        let fetchChannel = PublishRelay<Void>()
        let fetchDMRoom = PublishRelay<Void>()
        let spaceInfo = BehaviorRelay<SpaceInfo?>(value: nil)
        let channelSection = BehaviorRelay<[HomeSectionModel.Item]>(value: [])
        let dmRoomSection = BehaviorRelay<[HomeSectionModel.Item]>(value: [])
        let dataSource = PublishRelay<[HomeSectionModel]>()
        
        fetchSpaceInfo
            .map {
                SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
            }
            .withUnretained(self)
            .flatMap { owner, request in
                owner.spaceUseCase.getSpaceInfo(request: request)
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    spaceInfo.accept(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        fetchChannel
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.homeUseCase.fetchHomeChannelChatListWithCount()
            }
            .bind(with: self) { owner, channelList in
                var convertChannelList = channelList
                convertChannelList.append(HomeSectionItem.add(HomeAddText.channel.rawValue))
                channelSection.accept(convertChannelList)
                owner.channelSectionList = convertChannelList
            }
            .disposed(by: disposeBag)
        
        fetchDMRoom
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.homeUseCase.fetchHomeDMChatListWithCount()
            }
            .bind(with: self) { owner, dmRoomList in
                var convertDMRoomList = dmRoomList
                convertDMRoomList.append(HomeSectionItem.add(HomeAddText.dm.rawValue))
                dmRoomSection.accept(convertDMRoomList)
                owner.dmRoomSectionList = convertDMRoomList
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(channelSection, dmRoomSection)
            .bind(with: self) { owner, value in
                let sectionList = [
                    HomeSectionModel(
                        section: 0,
                        header: HomeSectionHeader.channel.rawValue,
                        isOpen: true,
                        items: value.0
                    ),
                    HomeSectionModel(
                        section: 1,
                        header: HomeSectionHeader.dm.rawValue,
                        isOpen: true,
                        items: value.1
                    ),
                    HomeSectionModel(
                        section: 2,
                        header: HomeSectionHeader.member.rawValue,
                        isOpen: false,
                        items: [HomeSectionModel.Item.add(HomeAddText.member.rawValue)]
                    )
                ]
                dataSource.accept(sectionList)
                owner.sections = sectionList
            }
            .disposed(by: disposeBag)
        
        input.fetchHomeDefaultTrigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.userUseCase.getMyProfile()
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myProfile):
                    myProfileImage.accept(myProfile.profileImage)
                    if UserDefaultsStorage.spaceId.isEmpty {
                        noSpace.accept(())
                    } else {
                        fetchSpaceInfo.accept(())
                        fetchChannel.accept(())
                        fetchDMRoom.accept(())
                    }
                case .failure:
                    backLoginView.accept(())
                }
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
                        owner.sections[value].items = owner.channelSectionList
                    case 1:
                        owner.sections[value].items = owner.dmRoomSectionList
                    default:
                        break
                    }
                }
                
                dataSource.accept(owner.sections)
            }
            .disposed(by: disposeBag)

        input.updateChannelTrigger
            .bind(with: self) { owner, _ in
                fetchChannel.accept(())
            }
            .disposed(by: disposeBag)
        
        input.updateChannelValueTrigger
            .withUnretained(self)
            .flatMap { owner, value in
                owner.homeUseCase.fetchHomeExistChannelListWithCount(channelList: value)
            }
            .bind(with: self) { owner, channelList in
                var convertChannelList = channelList
                convertChannelList.append(HomeSectionItem.add(HomeAddText.channel.rawValue))
                channelSection.accept(convertChannelList)
                owner.channelSectionList = convertChannelList
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(
            .updateHomeDefaultChannel
        )
        .asDriver(onErrorRecover: { _ in .never() })
        .drive(with: self) { owner, _ in
            fetchChannel.accept(())
        }
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(
            .updateHomeDefaultDM
        )
        .asDriver(onErrorRecover: { _ in .never() })
        .drive(with: self) { owner, _ in
            fetchDMRoom.accept(())
        }
        .disposed(by: disposeBag)
        
        return Output(
            myProfileImage: myProfileImage,
            noSpace: noSpace,
            spaceInfo: spaceInfo,
            dataSource: dataSource,
            backLoginView: backLoginView
        )
    }
}

extension HomeViewModel {
    enum HomeAddText: String {
        case channel = "채널 추가"
        case dm = "새메세지 시작"
        case member = "멤버 추가"
    }
    
    enum HomeSectionHeader: String {
        case channel = "채널"
        case dm = "다이렉트 메세지"
        case member = ""
    }
}
