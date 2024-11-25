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
    func fetchPersistChannelChat(channelID: String) -> Single<[Chat]>
    func fetchServerChannelChatList(request: ChatRequest)
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
    
    func fetchPersistChannelChat(channelID: String) -> Single<[Chat]> {
         return channelChatDatabase.fetch(channelId: channelID)
            .map { $0.map { $0.toDomain() } }
    }
    
    
    func fetchServerChannelChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>> {
        let requestDTO = request.toDTO()
        return channelRepository.fetchChannelChatList(
            requestDTO: requestDTO
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
