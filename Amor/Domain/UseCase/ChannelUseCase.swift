//
//  ChannelUseCase.swift
//  Amor
//
//  Created by 홍정민 on 12/1/24.
//

import Foundation
import RxSwift

protocol ChannelUseCase {
    func getMyChannels(request: ChannelRequestDTO)
    -> Single<Result<[Channel], NetworkError>>
//    func fetchSpaceChannels(request: ChannelRequestDTO)
//    -> Single<Result<[Channel], NetworkError>>
    func addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    ) -> Single<Result<Channel, NetworkError>>
    func editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    ) -> Single<Result<Channel, NetworkError>>
    func deleteChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<Empty, NetworkError>>
    func members(path: ChannelRequestDTO)
    -> Single<Result<[ChannelMember], NetworkError>>
    func exitChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<[Channel], NetworkError>>
    func changeAdmin(
        path: ChannelRequestDTO,
        body: ChangeAdminRequestDTO
    )
    -> Single<Result<Channel, NetworkError>>
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelDetail, NetworkError>>
    func validateAdmin(ownerID: String)
    -> Observable<Bool>
    func fetchHomeChannelChatListWithCount()
    -> Observable<[HomeSectionItem]>
    func fetchHomeExistChannelListWithCount(channelList: [Channel])
    -> Observable<[HomeSectionItem]>
}

final class DefaultChannelUseCase: ChannelUseCase {
    
    let channelRepository: ChannelRepository
    let channelChatDatabase: ChannelChatDatabase
    
    init(
        channelRepository: ChannelRepository,
        channelChatDatabase: ChannelChatDatabase
    ) {
        self.channelRepository = channelRepository
        self.channelChatDatabase = channelChatDatabase
    }
    
    func getMyChannels(request: ChannelRequestDTO)
    -> Single<Result<[Channel], NetworkError>> {
        channelRepository.fetchChannels(request: request)
            .flatMap { result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func addChannel(path: ChannelRequestDTO, body: AddChannelRequestDTO) 
    -> Single<Result<Channel, NetworkError>> {
        channelRepository.addChannel(path: path, body: body)
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func editChannel(path: ChannelRequestDTO, body: EditChannelRequestDTO) 
    -> Single<Result<Channel, NetworkError>> {
        return channelRepository.editChannel(
            path: path,
            body: body
        )
        .flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.toDomain()))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func deleteChannel(path: ChannelRequestDTO)
    -> Single<Result<Empty, NetworkError>> {
        return channelRepository.deleteChannel(
            path: path
        )
        .flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.toDomain()))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
    func exitChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<[Channel], NetworkError>> {
        return channelRepository.exitChannel(path: path)
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.map { $0.toDomain() }))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func changeAdmin(
        path: ChannelRequestDTO,
        body: ChangeAdminRequestDTO
    )
    -> Single<Result<Channel, NetworkError>> {
        channelRepository.changeAdmin(path: path, body: body)
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func members(path: ChannelRequestDTO)
    -> Single<Result<[ChannelMember], NetworkError>> {
        return channelRepository.members(path: path)
            .flatMap { result in
                switch result {
                case .success(let value):
                    let memberList = value
                        .filter { $0.user_id != UserDefaultsStorage.userId }
                        .map { $0.toDomain() }
                    return .just(.success(memberList))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelDetail, NetworkError>> {
        return channelRepository.fetchChannelDetail(channelID: channelID)
            .flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
    }
    
    func validateAdmin(ownerID: String) 
    -> Observable<Bool> {
        if ownerID == UserDefaultsStorage.userId {
            return .just(true)
        } else {
            return .just(false)
        }
    }
    
    func fetchHomeChannelChatListWithCount()
    -> Observable<[HomeSectionItem]> {
        let request = ChannelRequestDTO(workspaceId: UserDefaultsStorage.spaceId)
        let channelSectionList = channelRepository.fetchChannels(request: request)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<[HomeSectionItem]> in
                switch result {
                case .success(let value):
                    let channelList = value.map { channel in
                        let persistChatList = owner.channelChatDatabase.fetch(channelId: channel.channel_id)
                            .map { $0.map { $0.toDomain() } }
                            .asObservable()
                        
                        let unreadCount = persistChatList
                            .map { chat in
                                return chat.last?.createdAt ?? ""
                            }
                            .map { lastChatDate in
                                return UnreadChannelRequestDTO(
                                    channelID: channel.channel_id,
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    after: lastChatDate
                                )
                            }
                            .flatMap { request in
                                owner.channelRepository.fetchUnreadCount(request: request)
                            }
                            .flatMap { result -> Observable<Int> in
                                switch result {
                                case .success(let value):
                                    return .just(value.count)
                                case .failure(let error):
                                    print(error)
                                    return .just(0)
                                }
                            }
                        
                        let channelListContent = unreadCount
                            .map { unreadCount in
                                return HomeChannelListContent(
                                    channelID: channel.channel_id,
                                    channelName: channel.name,
                                    unreadCount: unreadCount
                                )
                            }
                            .map { listContent in
                                return HomeSectionItem.myChannelItem(listContent)
                            }
                        
                        return channelListContent
                    }
                    return Observable.zip(channelList).ifEmpty(default: [])
                case .failure(let error):
                    print(error)
                    return Observable.just([])
                }
            }
        return channelSectionList
    }
    
    func fetchHomeExistChannelListWithCount(channelList: [Channel])
    -> Observable<[HomeSectionItem]> {
        let channelSectionList = Observable.just(channelList)
            .withUnretained(self)
            .flatMap { owner, value -> Observable<[HomeSectionItem]> in
                let channelList = value.map { channel in
                    let persistChatList = owner.channelChatDatabase.fetch(channelId: channel.channel_id)
                        .map { $0.map { $0.toDomain() } }
                        .asObservable()
                    
                    let unreadCount = persistChatList
                        .map { chat in
                            return chat.last?.createdAt ?? ""
                        }
                        .map { lastChatDate in
                            return UnreadChannelRequestDTO(
                                channelID: channel.channel_id,
                                workspaceId: UserDefaultsStorage.spaceId,
                                after: lastChatDate
                            )
                        }
                        .flatMap { request in
                            owner.channelRepository.fetchUnreadCount(request: request)
                        }
                        .flatMap { result -> Observable<Int> in
                            switch result {
                            case .success(let value):
                                return .just(value.count)
                            case .failure(let error):
                                print(error)
                                return .just(0)
                            }
                        }
                    
                    let channelListContent = unreadCount
                        .map { unreadCount in
                            return HomeChannelListContent(
                                channelID: channel.channel_id,
                                channelName: channel.name,
                                unreadCount: unreadCount
                            )
                        }
                        .map { listContent in
                            return HomeSectionItem.myChannelItem(listContent)
                        }
                    
                    return channelListContent
                }
                
                return Observable.zip(channelList).ifEmpty(default: [])
            }
        return channelSectionList
    }
}
