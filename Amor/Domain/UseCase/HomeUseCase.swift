//
//  HomeUseCase.swift
//  Amor
//
//  Created by 홍정민 on 12/20/24.
//

import Foundation
import RxSwift

protocol HomeUseCase {
    func fetchHomeChannelChatListWithCount()
    -> Observable<[HomeSectionItem]>
    func fetchHomeExistChannelListWithCount(channelList: [Channel])
    -> Observable<[HomeSectionItem]>
    func fetchHomeDMChatListWithCount()
    -> Observable<[HomeSectionItem]>
}

final class DefaultHomeUseCase: HomeUseCase {
    private let channelChatDatabase: ChannelChatDatabase
    private let dmChatDatabase: DMChatDatabase
    private let channelRepository: ChannelRepository
    private let dmRepository: DMRepository
    
    init(channelChatDatabase: ChannelChatDatabase,
         dmChatDatabase: DMChatDatabase,
         channelRepository: ChannelRepository,
         dmRepository: DMRepository) {
        self.channelChatDatabase = channelChatDatabase
        self.dmChatDatabase = dmChatDatabase
        self.channelRepository = channelRepository
        self.dmRepository = dmRepository
    }

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
    
    func fetchHomeDMChatListWithCount()
    -> Observable<[HomeSectionItem]> {
        let request = DMRoomRequestDTO(workspace_id: UserDefaultsStorage.spaceId)
        let dmList = dmRepository.fetchDMRoomList(request: request)
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, result -> Observable<[HomeDMListContent]> in
                switch result {
                case .success(let value):
                    let dmList = value.map { room in
                        let persistChatList = owner.dmChatDatabase.fetch(roomId: room.room_id)
                            .map { $0.map { $0.toDomain() } }
                            .asObservable()
                        
                        let chatRequest = ChatRequestDTO(
                            workspaceId: UserDefaultsStorage.spaceId,
                            id: room.room_id,
                            cursor_date: ""
                        )
                        
                        let totalCount = owner.dmRepository.fetchServerDMChatList(request: chatRequest)
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
                                return UnreadDMRequstDTO(
                                    roomId: room.room_id,
                                    workspaceId: UserDefaultsStorage.spaceId,
                                    after: lastChatDate
                                )
                            }
                            .flatMap { request in
                                owner.dmRepository.fetchUnreadDMCount(request: request)
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
                        
                        let dmListContent = Observable.zip(persistChatList, totalCount, unreadCount)
                            .map { (persistChatList, totalCount, unreadCount) in
                                let savedCount = persistChatList.count
                                var convertUnreadCount = unreadCount
                                
                                if savedCount == 0 && unreadCount == 0 && totalCount > 0 {
                                    convertUnreadCount = totalCount
                                }
                                
                                let dmContent = HomeDMListContent(
                                    roomID: room.room_id,
                                    opponentProfile: room.user.profileImage,
                                    opponentName: room.user.nickname,
                                    totalChatCount: totalCount,
                                    unreadCount: convertUnreadCount)
                                return dmContent
                            }
                        
                        return dmListContent
                    }
                    return Observable.zip(dmList).ifEmpty(default: [])
                case .failure(let error):
                    print(error)
                    return Observable.just([])
                }
            }
        
        let dmSectionList = dmList.flatMap { contentList in
            let filteredList = contentList.filter { $0.totalChatCount > 0 }
                .map { HomeSectionItem.dmRoomItem($0) }
            return Observable.just(filteredList)
        }
        
        return dmSectionList
    }
}
