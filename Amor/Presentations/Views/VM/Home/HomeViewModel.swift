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
    let useCase: HomeUseCase
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: PublishSubject<Void>
    }
    
    struct Output {
        let dataSource: PublishSubject<[HomeSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let getMyChannels = PublishSubject<Void>()
        let getDMRooms = PublishSubject<Void>()
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
                    getMyChannels.onNext(())
                    getDMRooms.onNext(())
                    
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
                    print(convertDMRooms)
                    dmRoomArray.onNext(convertDMRooms)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(myChannelArray, dmRoomArray)
            .bind(with: self) { owner, value in
                let array = [HomeSectionModel(header: "채널", isOpen: true, items: value.0), HomeSectionModel(header: "다이렉트 메세지", isOpen: true, items: value.1), HomeSectionModel(header: "", isOpen: false, items: [HomeSectionModel.Item.addMember(HomeCollectionViewCellModel(name: "팀원 추가", image: "PlusMark"))])]
                dataSource.onNext(array)
            }
            .disposed(by: disposeBag)
            
        
        return Output(dataSource: dataSource)
    }
}
