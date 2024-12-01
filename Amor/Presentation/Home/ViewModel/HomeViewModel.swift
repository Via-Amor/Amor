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
    private let disposeBag = DisposeBag()
    private var sections: [HomeSectionModel] = []
    private var myChannels: [HomeSectionItem] = []
    private var dmRooms: [HomeSectionItem] = []
    private let userUseCase: UserUseCase
    private let spaceUseCase: SpaceUseCase
    private let channelUseCase: ChannelUseCase
    private let dmUseCase: DMUseCase
    
    init(userUseCase: UserUseCase, spaceUseCase: SpaceUseCase, channelUseCase: ChannelUseCase, dmUseCase: DMUseCase) {
        self.userUseCase = userUseCase
        self.spaceUseCase = spaceUseCase
        self.channelUseCase = channelUseCase
        self.dmUseCase = dmUseCase
    }
    
    struct Input {
        let trigger: BehaviorSubject<Void>
        let section: PublishSubject<Int>
        let fetchChannel: PublishSubject<Void>
    }
    
    struct Output {
        let myProfileImage: PublishSubject<String?>
        let noSpace: PublishSubject<Bool>
        let spaceInfo: PublishSubject<SpaceInfo>
        let dataSource: PublishSubject<[HomeSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let noSpace = PublishSubject<Bool>()
        let myProfileImage = PublishSubject<String?>()
        let getSpaceInfo = PublishSubject<Void>()
        let getMyChannels = PublishSubject<Void>()
        let getDMRooms = PublishSubject<Void>()
        let spaceInfo = PublishSubject<SpaceInfo>()
        let myChannelArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dmRoomArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dataSource = PublishSubject<[HomeSectionModel]>()
        
        input.trigger
            .map { LoginRequestModel(email: "qwe123@gmail.com", password: "Qwer1234!") }
            .flatMap { self.userUseCase.login(request: $0) }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let login):
                    UserDefaultsStorage.userId = login.user_id
                    UserDefaultsStorage.token = login.token.accessToken
                    UserDefaultsStorage.refresh = login.token.refreshToken
                    KingfisherManager.shared.setDefaultModifier()
                    myProfileImage.onNext(login.profileImage)
                    
                    if UserDefaultsStorage.spaceId.isEmpty {
                        noSpace.onNext(true)
                    } else {
                        noSpace.onNext(false)
                        getSpaceInfo.onNext(())
                        getMyChannels.onNext(())
                        getDMRooms.onNext(())
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getSpaceInfo
            .map { SpaceRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap({ self.spaceUseCase.getSpaceInfo(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let success):
                    spaceInfo.onNext(success)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getMyChannels
            .map{ ChannelRequestDTO() }
            .flatMap({ self.channelUseCase.getMyChannels(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myChannels):
                    var convertChannels = myChannels.map {
                        HomeSectionModel.Item.myChannelItem($0)
                    }
                    
                    convertChannels.append(
                        HomeSectionModel.Item
                            .add(HomeAddText.channel.rawValue)
                    )
                    
                    myChannelArray.onNext(convertChannels)
                    owner.myChannels = convertChannels
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getDMRooms
            .map { DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId) }
            .flatMap({ self.dmUseCase.getDMRooms(request: $0) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dmRooms):
                    var convertDMRooms = dmRooms.map {
                        HomeSectionModel.Item.dmRoomItem($0)
                    }
                    
                    convertDMRooms.append(
                        HomeSectionModel.Item
                            .add(HomeAddText.dm.rawValue)
                    )
                    
                    dmRoomArray.onNext(convertDMRooms)
                    owner.dmRooms = convertDMRooms
                case .failure(let error):
                    print(error)
                }
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
        
        input.section
            .bind(with: self) { owner, value in
                print(value)
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
        
        input.fetchChannel
            .bind(to: getMyChannels)
            .disposed(by: disposeBag)
        
        return Output(myProfileImage: myProfileImage, noSpace: noSpace, spaceInfo: spaceInfo, dataSource: dataSource)
    }
}
