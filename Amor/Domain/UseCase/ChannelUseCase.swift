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
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelDetail, NetworkError>>
    func validateAdmin(ownerID: String)
    -> Observable<Bool>
}

final class DefaultChannelUseCase: ChannelUseCase {
    let channelRepository: ChannelRepository
    
    init(channelRepository: ChannelRepository) {
        self.channelRepository = channelRepository
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
