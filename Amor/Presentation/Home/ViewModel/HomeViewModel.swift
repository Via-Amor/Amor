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
    private let disposeBag = DisposeBag()
    
    private var sections: [HomeSectionModel] = []
    private var myChannels: [HomeSectionItem] = []
    private var dmRooms: [HomeSectionItem] = []
    
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
        let viewDidLoadTrigger: Observable<Void>
        let fetchHomeDefaultTrigger: PublishRelay<Void>
        let updateChannelTrigger: PublishRelay<Void>
        let updateChannelValueTrigger: PublishRelay<[Channel]>
        let toggleSection: PublishRelay<Int>
        let fetchHome: PublishRelay<Void>
        let showToast: PublishRelay<String>
    }
    
    struct Output {
        let myProfileImage: PublishRelay<String?>
        let noSpace: PublishRelay<Void>
        let spaceInfo: BehaviorRelay<SpaceInfo?>
        let dataSource: PublishRelay<[HomeSectionModel]>
        let backLoginView: PublishRelay<Void>
        let toastMessage: PublishRelay<String>
    }
    
    func transform(_ input: Input) -> Output {
        let backLoginView = PublishRelay<Void>()
        let noSpace = PublishRelay<Void>()
        let myProfileImage = PublishRelay<String?>()
        
        let getSpaceInfo = PublishRelay<Void>()
        let getMyChannels = PublishRelay<Void>()
        let getDMRooms = PublishRelay<Void>()
        
        let spaceInfo = BehaviorRelay<SpaceInfo?>(value: nil)
        let myChannelArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dmRoomArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dataSource = PublishRelay<[HomeSectionModel]>()
        
        let toastMessage = PublishRelay<String>()
        
        input.fetchHomeDefaultTrigger
            .flatMap {
                self.userUseCase.getMyProfile()
            }
            .debug("홈")
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myProfile):
                    myProfileImage.accept(myProfile.profileImage)
                    if UserDefaultsStorage.spaceId.isEmpty {
                        noSpace.accept(())
                    } else {
                        getSpaceInfo.accept(())
                        getMyChannels.accept(())
                        getDMRooms.accept(())
                    }
                case .failure:
                    backLoginView.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoadTrigger
            .debug("viewDidLoad")
            .bind(with: self) { owner, _ in
                input.fetchHomeDefaultTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
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
                dataSource.accept(array)
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
                
                dataSource.accept(owner.sections)
            }
            .disposed(by: disposeBag)

        input.updateChannelTrigger
            .bind(with: self) { owner, _ in
                getMyChannels.accept(())
            }
            .disposed(by: disposeBag)
        
        input.updateChannelValueTrigger
            .withUnretained(self)
            .flatMap { owner, value in
                owner.channelUseCase.fetchHomeExistChannelListWithCount(channelList: value)
            }
            .bind(with: self) { owner, channelList in
                var channelSection = channelList
                channelSection.append(HomeSectionItem.add(HomeAddText.channel.rawValue))
                myChannelArray.onNext(channelSection)
                owner.myChannels = channelSection
            }
            .disposed(by: disposeBag)
        
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
