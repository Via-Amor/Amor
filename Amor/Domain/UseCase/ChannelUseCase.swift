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
    
    // 홈
    func fetchHomeChannelChatListWithCount()
    -> Observable<[HomeSectionItem]>
    func fetchHomeExistChannelListWithCount(channelList: [Channel])
    -> Observable<[HomeSectionItem]>
    
    // 채널탐색에서 사용
    func fetchChannelList()
    -> Observable<[ChannelList]>
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
        channelRepository.fetchMyChannels(request: request)
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

}

extension DefaultChannelUseCase {
    func fetchHomeChannelChatListWithCount()
    -> Observable<[HomeSectionItem]> {
        let request = ChannelRequestDTO(workspaceId: UserDefaultsStorage.spaceId)
        let channelSectionList = channelRepository.fetchMyChannels(request: request)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<[HomeSectionItem]> in
                switch result {
                case .success(let value):
                    let channelList = value.map { channel in
                        let persistChatList = owner.channelChatDatabase.fetch(channelId: channel.channel_id)
                            .map { $0.map { $0.toDomain() } }
                            .asObservable()
                        
                        let request = ChatRequestDTO(
                            workspaceId: UserDefaultsStorage.spaceId,
                            id: channel.channel_id,
                            cursor_date: ""
                        )
                        let totalCount = owner.channelRepository.fetchChatList(request: request)
                            .flatMap { result in
                                switch result {
                                case .success(let value):
                                    return .just(value.count)
                                case .failure(let error):
                                    print(error)
                                    return .just(0)
                                }
                            }
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
                        
                        let channelListContent = Observable.zip(persistChatList, totalCount, unreadCount)
                            .map { persistChatList, totalCount, unreadCount in
                                let savedCount = persistChatList.count
                                var convertUnreadCount = unreadCount
                                
                                if savedCount == 0 && unreadCount == 0 && totalCount > 0 {
                                    convertUnreadCount = totalCount
                                }
                                
                                return HomeChannelListContent(
                                    channelID: channel.channel_id,
                                    channelName: channel.name,
                                    unreadCount: convertUnreadCount
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
                    
                    let request = ChatRequestDTO(
                        workspaceId: UserDefaultsStorage.spaceId,
                        id: channel.channel_id,
                        cursor_date: ""
                    )
                    let totalCount = owner.channelRepository.fetchChatList(request: request)
                        .flatMap { result in
                            switch result {
                            case .success(let value):
                                return .just(value.count)
                            case .failure(let error):
                                print(error)
                                return .just(0)
                            }
                        }
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
                    
                    let channelListContent = Observable.zip(persistChatList, totalCount, unreadCount)
                        .map { persistChatList, totalCount, unreadCount in
                            let savedCount = persistChatList.count
                            var convertUnreadCount = unreadCount
                            
                            if savedCount == 0 && unreadCount == 0 && totalCount > 0 {
                                convertUnreadCount = totalCount
                            }
                            
                            return HomeChannelListContent(
                                channelID: channel.channel_id,
                                channelName: channel.name,
                                unreadCount: convertUnreadCount
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


extension DefaultChannelUseCase {
    func fetchChannelList()
    -> Observable<[ChannelList]> {
        let channelRequest = ChannelRequestDTO(workspaceId: UserDefaultsStorage.spaceId)
        let spaceChannelList = channelRepository.fetchSpaceChannels(request: channelRequest).asObservable()
        let myChannelList = channelRepository.fetchMyChannels(request: channelRequest).asObservable()
        
        let channelList = Observable.zip(spaceChannelList, myChannelList)
            .map { spaceChannelResult, myChannelResult in
                let value = (spaceChannelResult, myChannelResult)
                switch value {
                case (.success(let spaceChannel), .success(let myChannel)):
                    let channelList = spaceChannel.map { channel in
                        let isAttend = myChannel.contains { $0.channel_id == channel.channel_id }
                        return ChannelList(
                            channel_id: channel.channel_id,
                            name: channel.name,
                            description: channel.description,
                            coverImage: channel.coverImage,
                            owner_id: channel.owner_id,
                            isAttend: isAttend
                        )
                    }
                    return channelList
                default:
                    return []
                }
            }
        
        return channelList
    }
}
