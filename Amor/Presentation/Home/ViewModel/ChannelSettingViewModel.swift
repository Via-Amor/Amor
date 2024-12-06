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
    let channelUseCase: ChannelUseCase
    let chatUseCase: ChatUseCase
    let channelID: String
    private let disposeBag = DisposeBag()
    
    init(
        channelUseCase: ChannelUseCase,
        chatUseCase: ChatUseCase,
        channelID: String
    ) {
        self.channelUseCase = channelUseCase
        self.chatUseCase = chatUseCase
        self.channelID = channelID
    }
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let channelUpdateTrigger: PublishRelay<Bool>
        let channelDeleteTrigger: PublishRelay<Void>
        let channelExitTrigger: PublishRelay<Void>
        let editChannelTap: ControlEvent<Void>
        let deleteChannelTap: ControlEvent<Void>
        let exitChannelTap: ControlEvent<Void>
    }
    
    struct Output {
        let channelInfo: Driver<ChannelDetail>
        let memberSection: Driver<[ChannelSettingSectionModel]>
        let isAdmin: Signal<Bool>
        let presentErrorToast: Signal<String>
        let presentEditChannel: Signal<EditChannel>
        let presentDeleteChannel: Signal<Void>
        let presentExitChannel: Signal<Bool>
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
        let presentDeleteChannel = PublishRelay<Void>()
        let presentExitChannel = PublishRelay<Bool>()
        let presentHomeDefault = PublishRelay<Void>()
        
        validateAdmin
            .withUnretained(self)
            .flatMap { _, ownerID in
                self.channelUseCase.validateAdmin(ownerID: ownerID)
            }
            .asDriver { _ in .never() }
            .drive { value in
                isAdmin.accept(value)
            }
            .disposed(by: disposeBag)
        
        callChannelDetail
            .withUnretained(self)
            .flatMap { _ in
                self.channelUseCase.fetchChannelDetail(channelID: self.channelID)
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
                self.channelUseCase.deleteChannel(path: path)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    owner.chatUseCase.deleteAllPersistChannelChat(channelID: owner.channelID)
                    presentHomeDefault.accept(())
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        // 서버통신
        // 디비 값 삭제
        // 홈으로 변경되면서 채널로 PUSH
        
//        input.channelExitTrigger
        
        
        
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
        
        input.deleteChannelTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                presentDeleteChannel.accept(())
            }
            .disposed(by: disposeBag)
        
        input.exitChannelTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(isAdmin)
            .bind(with: self) { owner, isAdmin in
                presentExitChannel.accept(isAdmin)
            }
            .disposed(by: disposeBag)
        
        return Output(
            channelInfo: channelInfo.asDriver(), 
            memberSection: memberSection.asDriver(),
            isAdmin: isAdmin.asSignal(),
            presentErrorToast: presentErrorToast.asSignal(),
            presentEditChannel: presentEditChannel.asSignal(),
            presentDeleteChannel: presentDeleteChannel.asSignal(), 
            presentExitChannel: presentExitChannel.asSignal(),
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
