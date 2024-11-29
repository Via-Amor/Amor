//
//  ChatUseCase.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatUseCase {
    // Network
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelSummary, NetworkError>>
    func fetchServerChannelChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>>
   
    // DB
    func insertPersistChannelChat(chatList: [Chat])
    func insertPersistChannelChat(chat: Chat)
    func fetchPersistChannelChat(channelID: String)
    -> Single<[Chat]>
    
    // Socket
    func receiveSocketChannelChat(channelID: String)
    -> Observable<Chat>
    func closeSocketConnection()
}


final class DefaultChatUseCase: ChatUseCase {
    private let channelChatDatabase: ChannelDatabase
    private let channelRepository: ChannelRepository
    private let socketIOManager: SocketIOManager
    
    init(channelChatDatabase: ChannelDatabase,
         channelRepository: ChannelRepository,
         socketIOManager: SocketIOManager) {
        self.channelChatDatabase = channelChatDatabase
        self.channelRepository = channelRepository
        self.socketIOManager = socketIOManager
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

// DB
extension DefaultChatUseCase {
    func insertPersistChannelChat(chatList: [Chat]) {
        channelChatDatabase.insert(chatList: chatList.map { $0.toDTO() })
    }
    
    func insertPersistChannelChat(chat: Chat) {
        channelChatDatabase.insert(chat: chat.toDTO())
    }
    
    func fetchPersistChannelChat(channelID: String)
    -> Single<[Chat]> {
        return channelChatDatabase.fetch(channelId: channelID)
            .map { $0.map { $0.toDomain() } }
    }
}

// Socket
extension DefaultChatUseCase {
    func receiveSocketChannelChat(channelID: String)
    -> Observable<Chat> {
        let router = ChannelRouter.channel(id: channelID)
        socketIOManager.establishConnection(router: router)
        return socketIOManager.receive().map { $0.toDomain() }
    }

    
    func closeSocketConnection() {
        NotificationCenter.default.post(
            name: .disconnect,
            object: nil
        )
    }
}
