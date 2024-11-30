//
//  ChannelSettingViewModel.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelSettingViewModel: BaseViewModel {
    let useCase: HomeUseCase
    let channelID: String
    private let disposeBag = DisposeBag()
    
    init(useCase: HomeUseCase, channelID: String) {
        self.useCase = useCase
        self.channelID = channelID
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        let channelInfo: Driver<ChannelDetail>
        let memberSection: Driver<[ChannelSettingSectionModel]>
        let presentErrorToast: Signal<String>
    }
    
    func transform(_ input: Input) -> Output {
        let channelInfo = BehaviorRelay<ChannelDetail>(
            value: ChannelDetail(
                channel_id: "",
                name: "",
                description: "",
                coverImage: "",
                owner_id: "'",
                createdAt: "",
                channelMembers: []
            )
        )
        let memberSection = BehaviorRelay<[ChannelSettingSectionModel]>(
            value: [ChannelSettingSectionModel(header: "", items: [])]
        )
        let presentErrorToast = PublishRelay<String>()

        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchChannelDetail(channelID: self.channelID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    // 채팅방 정보
                    channelInfo.accept(value)
                    
                    // 멤버 정보(컬렉션뷰)
                    let header = "멤버 \(value.channelMembers.count)"
                    let items = value.channelMembers
                    let section = ChannelSettingSectionModel(
                        header: header,
                        items: items
                    )
                    memberSection.accept([section])
                case .failure(let error):
                    print("채널 정보조회 오류 ❌", error)
                    presentErrorToast.accept(ToastText.channelSettingError)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            channelInfo: channelInfo.asDriver(),
            memberSection: memberSection.asDriver(),
            presentErrorToast: presentErrorToast.asSignal()
        )
    }
}

