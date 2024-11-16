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
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let dataSource: BehaviorSubject<[HomeSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let getMyChannels = PublishSubject<Void>()
        let getDMRooms = PublishSubject<Void>()
        let myChannelArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dmRoomArray = BehaviorSubject<[HomeSectionModel.Item]>(value: [])
        let dataSource = BehaviorSubject<[HomeSectionModel]>(value: [])
        let fetchEnd = PublishRelay<Void>()
        
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
                    let convertChannels = myChannels.map({ HomeSectionModel.Item.myChannelItem($0) })
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
                    let convertDMRooms = dmRooms.map({ HomeSectionModel.Item.dmRoomItem($0) })
                    dmRoomArray.onNext(convertDMRooms)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(myChannelArray, dmRoomArray)
            .bind(with: self) { owner, value in
                let array = [HomeSectionModel(header: "채널", items: value.0), HomeSectionModel(header: "다이렉트 메세지", items: value.1)]
                dataSource.onNext(array)
            }
            .disposed(by: disposeBag)
            
        
        return Output(dataSource: dataSource)
    }
}
