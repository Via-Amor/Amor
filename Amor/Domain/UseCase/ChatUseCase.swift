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
    func fetchServerChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>>
    func postServerChatList(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>>
   
    // DB
    func insertPersistChat(chatList: [Chat])
    func insertPersistChat(chat: Chat)
    func fetchPersistChat(id: String)
    -> Single<[Chat]>
    func deleteAllPersistChat(id: String)
    
    // Socket
    func receiveSocketChat(chatType: ChatType)
    -> Observable<Chat>
    func closeSocketConnection()
}


final class DefaultChatUseCase: ChatUseCase {
    
    private let chatDataBase: DataBase
    private let chatRepository: ChatRepository
    private let socketIOManager: SocketIOManager

    init(chatDataBase: DataBase,
         chatRepository: ChatRepository,
         socketIOManager: SocketIOManager) {
        self.chatDataBase = chatDataBase
        self.chatRepository = chatRepository
        self.socketIOManager = socketIOManager
    }
    
    func fetchServerChatList(request: ChatRequest)
    -> Single<Result<[Chat], NetworkError>> {
        let requestDTO = request.toDTO()
        switch self.chatRepository {
        case let channelRepository as ChannelRepository:
            return channelRepository.fetchChatList(
                requestDTO: requestDTO
            ).flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.map { $0.toDomain() }))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
        case let dmRepository as DMRepository:
            return dmRepository.fetchChatList(
                requestDTO: requestDTO
            ).flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.map { $0.toDomain() }))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
        default:
            return .just(.failure(.invalidStatus))
        }
    }
    
    func postServerChatList(request: ChatRequest, body: ChatRequestBody)
    -> Single<Result<Chat, NetworkError>> {
        let requestDTO = request.toDTO()
        let bodyDTO = body.toDTO()
        
        switch self.chatRepository {
        case let channelRepository as ChannelRepository:
            return channelRepository.postChat(
                requestDTO: requestDTO,
                bodyDTO: bodyDTO
            ).flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
        case let dmRepository as DMRepository:
            return dmRepository.postChat(
                requestDTO: requestDTO,
                bodyDTO: bodyDTO
            ).flatMap { result in
                switch result {
                case .success(let value):
                    return .just(.success(value.toDomain()))
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
            
        default:
            print("postServerChatList Error")
            return .just(.failure(.invalidStatus))
        }
    }
}

// DB
extension DefaultChatUseCase {
    func insertPersistChat(chatList: [Chat]) {
        print(chatList)
        if !chatList.isEmpty {
            switch chatDataBase {
            case let channelChatDatabase as ChannelChatDatabase:
                return channelChatDatabase.insert(chatList: chatList.map { $0.toDTO() })
            case let dmChatDataBase as DMChatDataBase:
                return dmChatDataBase.insert(chatList: chatList.map { $0.toDTO() })
            default:
                print("insertPersistChat([Chat]) Error")
                break
            }
        }
    }
    
    func insertPersistChat(chat: Chat) {
        switch chatDataBase {
        case let channelChatDatabase as ChannelChatDatabase:
            return channelChatDatabase.insert(chat: chat.toDTO())
        case let dmChatDataBase as DMChatDataBase:
            return dmChatDataBase.insert(chat: chat.toDTO())
        default:
            print("insertPersistChat(Chat) Error")
            break
        }
    }
    
    func fetchPersistChat(id: String)
    -> Single<[Chat]> {
        switch chatDataBase {
        case let channelChatDatabase as ChannelChatDatabase:
            return channelChatDatabase.fetch(channelId: id)
                .map { $0.map { $0.toDomain() } }
        case let dmChatDataBase as DMChatDataBase:
            return dmChatDataBase.fetch(roomId: id)
                .map { $0.map { $0.toDomain() } }
        default:
            print("fetchPersistChat Error")
            return Single.just([])
        }
    }
    
    func deleteAllPersistChat(id: String) {
        switch chatDataBase {
        case let channelChatDatabase as ChannelChatDatabase:
            return channelChatDatabase.deleteAll(channelId: id)
        case let dmChatDataBase as DMChatDataBase:
            return dmChatDataBase.deleteAll(dmId: id)
        default:
            print("deleteAllPersistChat Error")
            break
        }
    }
}

// Socket
extension DefaultChatUseCase {
    func receiveSocketChat(chatType: ChatType)
    -> Observable<Chat> {
        let router: SocketRouter
        switch chatType {
        case .channel(let channel):
            router = .channel(id: channel.channel_id)
        case .dm(let dmRoom):
            router = .dm(id: dmRoom?.room_id ?? "")
        }
        
        socketIOManager.establishConnection(router: router)
        return socketIOManager.receive(chatType: chatType).map { $0.toDomain() }
    }
    
    func closeSocketConnection() {
        NotificationCenter.default.post(
            name: .disconnect,
            object: nil
        )
    }
}
