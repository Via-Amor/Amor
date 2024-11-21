//
//  HomeViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private var sections: [HomeSectionModel] = []
    private var myChannels: [HomeSectionItem] = []
    private var dmRooms: [HomeSectionItem] = []
    let useCase: HomeUseCase
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: PublishSubject<Void>
        let section: PublishSubject<Int>
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
            .flatMap({ self.useCase.login() })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let login):
                    UserDefaultsStorage.userId = login.user_id
                    UserDefaultsStorage.token = login.token.accessToken
                    UserDefaultsStorage.refresh = login.token.refreshToken
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
            .flatMap({ self.useCase.getSpaceInfo(spaceID: UserDefaultsStorage.spaceId) })
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
            .flatMap({ self.useCase.getMyChannels(spaceID: UserDefaultsStorage.spaceId) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let myChannels):
//                    let array = Array(repeating: HomeMyChannel(ChannelResponseDTO(channel_id: "", name: "채널", description: "", coverImage: "", owner_id: "", createdAt: "")), count: 10)
                    var convertChannels = myChannels.map({ HomeSectionModel.Item.myChannelItem(HomeCollectionViewCellModel(name: $0.name, image: "Hashtag_light")) })
                    convertChannels.append(HomeSectionModel.Item.myChannelItem(HomeCollectionViewCellModel(name: "채널 추가", image: "PlusMark")))
                    myChannelArray.onNext(convertChannels)
                    owner.myChannels = convertChannels
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        getDMRooms
            .flatMap({ self.useCase.getDMRooms(spaceID: UserDefaultsStorage.spaceId) })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let dmRooms):
//                    let array = Array(repeating: DMRoom(DMRoomResponseDTO(room_id: "123", createdAt: "123", user: DMUserResponseDTO(user_id: "123", email: "212", nickname: "새싹이", profileImage: nil))), count: 10)
                    let randomProfile = ["User_green", "User_pink", "User_skyblue"].randomElement()!
                    var convertDMRooms = dmRooms.map({ HomeSectionModel.Item.dmRoomItem(HomeCollectionViewCellModel(name: $0.user.nickname, image: $0.user.profileImage ?? randomProfile)) })
                    convertDMRooms.append(HomeSectionModel.Item.dmRoomItem(HomeCollectionViewCellModel(name: "새 메세지 시작", image: "PlusMark")))
                    dmRoomArray.onNext(convertDMRooms)
                    owner.dmRooms = convertDMRooms
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(myChannelArray, dmRoomArray)
            .bind(with: self) { owner, value in
                let array = [HomeSectionModel(section: 0, header: "채널", isOpen: true, items: value.0), HomeSectionModel(section: 1, header: "다이렉트 메세지", isOpen: true, items: value.1), HomeSectionModel(section: 2, header: "", isOpen: false, items: [HomeSectionModel.Item.addMember(HomeCollectionViewCellModel(name: "팀원 추가", image: "PlusMark"))])]
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
        

        
        return Output(myProfileImage: myProfileImage, noSpace: noSpace, spaceInfo: spaceInfo, dataSource: dataSource)
    }
}
