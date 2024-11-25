//
//  ChatUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RxSwift

protocol ChatUseCase {
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelSummary, NetworkError>>
    func insertPersistChannelChat(chatList: [Chat])
    func fetchPersistChannelChat(channelId: String) -> Observable<[Chat]>
    func fetchServerChannelChatList(path: ChannelRequestDTO, query: ChatListRequestDTO)
    -> Single<Result<[Chat], NetworkError>>
}

final class DefaultChatUseCase: ChatUseCase {
    // 채팅에 사용되는 데이터베이스
    private let channelChatDatabase: ChannelDatabase
    // 채팅에 사용되는 채널 정보
    private let channelRepository: ChannelRepository
    
    init(channelChatDatabase: ChannelDatabase,
         channelRepository: ChannelRepository) {
        self.channelChatDatabase = channelChatDatabase
        self.channelRepository = channelRepository
    }
    
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelSummary, NetworkError>> {
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
    
    func insertPersistChannelChat(chatList: [Chat]) {
        channelChatDatabase.insert(chatList: chatList.map { $0.toDTO() })
    }
    
    func fetchPersistChannelChat(channelId: String) -> Observable<[Chat]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let chatList = self.channelChatDatabase.fetch(channelId: channelId)
            observer.onNext(chatList.map { $0.toDomain() })
            return Disposables.create()
        }
    }
    
    
    func fetchServerChannelChatList(path: ChannelRequestDTO, query: ChatListRequestDTO)
    -> Single<Result<[Chat], NetworkError>> {
        return channelRepository.fetchChannelChatList(
            path: path,
            query: query
        ).flatMap { result in
            switch result {
            case .success(let value):
                return .just(.success(value.map { $0.toDomain() }))
            case .failure(let error):
                return .just(.failure(error))
            }
        }
    }
    
}
