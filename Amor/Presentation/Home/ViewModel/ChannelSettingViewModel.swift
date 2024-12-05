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
    let useCase: ChannelUseCase
    let channelID: String
    private let disposeBag = DisposeBag()
    
    init(useCase: ChannelUseCase, channelID: String) {
        self.useCase = useCase
        self.channelID = channelID
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let channelUpdateTrigger: PublishRelay<Bool>
        let channelDeleteTrigger: PublishRelay<Void>
        let editChannelTap: ControlEvent<Void>
    }
    
    struct Output {
        let channelInfo: Driver<ChannelDetail>
        let memberSection: Driver<[ChannelSettingSectionModel]>
        let isAdmin: Signal<Bool>
        let presentErrorToast: Signal<String>
        let presentEditChannel: Signal<EditChannel>
        let presentHomeDefault: Signal<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let channelInfo = BehaviorRelay<ChannelDetail>(
            value: createInitialChannelInfo()
        )
        let memberSection = BehaviorRelay<[ChannelSettingSectionModel]>(
            value: createInitialMemberSection()
        )
        let isAdmin = PublishRelay<Bool>()
        let callChannelDetail = PublishRelay<Void>()
        let validateAdmin = PublishRelay<String>()
        let presentErrorToast = PublishRelay<String>()
        let presentEditChannel = PublishRelay<EditChannel>()
        let presentHomeDefault = PublishRelay<Void>()
        
        validateAdmin
            .withUnretained(self)
            .flatMap { _, ownerID in
                self.useCase.validateAdmin(ownerID: ownerID)
            }
            .asDriver { _ in .never() }
            .drive { value in
                isAdmin.accept(value)
            }
            .disposed(by: disposeBag)
        
        callChannelDetail
            .withUnretained(self)
            .flatMap { _ in
                self.useCase.fetchChannelDetail(channelID: self.channelID)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    channelInfo.accept(value)
                    let section = owner.createMemberSection(value)
                    memberSection.accept([section])
                    validateAdmin.accept(value.owner_id)
                case .failure(let error):
                    print("채널 정보조회 오류 ❌", error)
                    presentErrorToast.accept(ToastText.channelSettingError)
                }
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppearTrigger
            .bind(with: self) { owner, _ in
                callChannelDetail.accept(())
            }
            .disposed(by: disposeBag)
        
        input.channelUpdateTrigger
            .filter { $0 }
            .bind(with: self) { owner, _ in
                callChannelDetail.accept(())
            }
            .disposed(by: disposeBag)
        
        input.channelDeleteTrigger
            .withUnretained(self)
            .map { _ in
                let request = ChannelRequestDTO(channelId: self.channelID)
                return request
            }
            .flatMap { path in
                self.useCase.deleteChannel(path: path)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let value):
                    presentHomeDefault.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        input.editChannelTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(channelInfo)
            .map { channelInfo in
                return EditChannel(
                    channelID: channelInfo.channel_id,
                    name: channelInfo.name,
                    description: channelInfo.description
                )
            }
            .bind(with: self) { owner, editChannel in
                presentEditChannel.accept(editChannel)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            channelInfo: channelInfo.asDriver(), 
            memberSection: memberSection.asDriver(),
            isAdmin: isAdmin.asSignal(),
            presentErrorToast: presentErrorToast.asSignal(),
            presentEditChannel: presentEditChannel.asSignal(),
            presentHomeDefault: presentHomeDefault.asSignal()
        )
    }
}

extension ChannelSettingViewModel {
    private func createInitialChannelInfo() -> ChannelDetail {
        return ChannelDetail(
            channel_id: "",
            name: "",
            description: "",
            coverImage: "",
            owner_id: "'",
            createdAt: "",
            channelMembers: []
        )
    }
    
    private func createInitialMemberSection() -> [ChannelSettingSectionModel] {
        return [ChannelSettingSectionModel(header: "", items: [])]
    }
    
    private func createMemberSection(_ channelDetail : ChannelDetail)
    -> ChannelSettingSectionModel {
        let header = "멤버 \(channelDetail.channelMembers.count)"
        let items = channelDetail.channelMembers
        let section = ChannelSettingSectionModel(
            header: header,
            items: items
        )
        return section
    }
}
