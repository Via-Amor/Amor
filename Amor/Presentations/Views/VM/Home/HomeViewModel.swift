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
        let myChannelArray: BehaviorSubject<[HomeMyChannel]>
        let dmRoomArray: BehaviorSubject<[DMRoom]>
        let fetchEnd: PublishRelay<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let getMyChannels = PublishSubject<Void>()
        let getDMRooms = PublishSubject<Void>()
        let myChannelArray = BehaviorSubject<[HomeMyChannel]>(value: [])
        let dmRoomArray = BehaviorSubject<[DMRoom]>(value: [])
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
                    myChannelArray.onNext(myChannels)
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
                    dmRoomArray.onNext(dmRooms)
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(myChannelArray, dmRoomArray)
            .bind(with: self) { owner, value in
                fetchEnd.accept(())
            }
            .disposed(by: disposeBag)
            
        
        return Output(myChannelArray: myChannelArray, dmRoomArray: dmRoomArray, fetchEnd: fetchEnd)
    }
}
