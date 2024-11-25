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
    func fetchPersistChannelChat() -> Observable<[Chat]>
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
    
    func fetchPersistChannelChat() -> Observable<[Chat]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let chatList = self.channelChatDatabase.fetch()
            observer.onNext(chatList.map { $0.toDomain() })
            return Disposables.create()
        }
    }
    
}
