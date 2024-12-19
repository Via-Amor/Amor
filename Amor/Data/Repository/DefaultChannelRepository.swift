//
//  DefaultHomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

final class DefaultChannelRepository: ChannelRepository {
    private let networkManager: NetworkType
    private let disposeBag = DisposeBag()
    
    init(_ networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    func fetchSpaceChannels(request: ChannelRequestDTO)
    -> Single<Result<[ChannelResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getSpaceChannels(query: request),
            response: [ChannelResponseDTO].self
        )
    }
    
    func fetchMyChannels(request: ChannelRequestDTO)
    -> Single<Result<[ChannelResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getMyChannels(query: request),
            response: [ChannelResponseDTO].self
        )
    }
    
    func fetchChannelDetail(channelID: String)
    -> Single<Result<ChannelDetailResponseDTO, NetworkError>> {
        let channelRequestDTO = ChannelRequestDTO(channelId: channelID)
        return networkManager.callNetwork(
            target: ChannelTarget.getChannelDetail(
                query: channelRequestDTO
            ),
            response: ChannelDetailResponseDTO.self
        )
    }
    
    func addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    ) -> Single<Result<ChannelResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.addChannel(path: path, body: body),
            response: ChannelResponseDTO.self)
    }
    
    func editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    ) -> Single<Result<ChannelResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.editChannel(path: path, body: body),
            response: ChannelResponseDTO.self
        )
    }
    
    func deleteChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<EmptyResponseDTO, NetworkError>> {
        return networkManager.callNetworkEmptyResponse(
            target: ChannelTarget.deleteChannel(path: path))
    }
    
    func exitChannel(path: ChannelRequestDTO)
    -> Single<Result<[ChannelResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.exitChannel(
                path: path
            ),
            response: [ChannelResponseDTO].self
        )
    }
    
    func changeAdmin(
        path: ChannelRequestDTO,
        body: ChangeAdminRequestDTO
    )
    -> Single<Result<ChannelResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.changeAdmin(
                path: path,
                body: body
            ),
            response: ChannelResponseDTO.self
        )
    }
    
    func members(path: ChannelRequestDTO)
    -> Single<Result<[ChannelMemberDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.members(path: path),
            response: [ChannelMemberDTO].self
        )
    }
    
    func fetchUnreadCount(request: UnreadChannelRequestDTO)
    -> Single<Result<UnreadChannelResponseDTO, NetworkError>>{
        return networkManager.callNetwork(
            target: ChannelTarget.getUnread(request: request),
            response: UnreadChannelResponseDTO.self
        )
    }
    
    func fetchChatList(request: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getChannelChatList(request: request),
            response: [ChannelChatResponseDTO].self
        )
        .map { result in
            switch result {
            case .success(let suceess):
                let chatResponses = suceess.map { $0.toDTO() }
                return .success(chatResponses)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func postChat(path: ChatRequestDTO, body: ChatRequestBodyDTO)
    -> Single<Result<ChatResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.postChannelChat(path: path, body: body),
            response: ChannelChatResponseDTO.self
        ).map { result in
            switch result {
            case .success(let suceess):
                let chatResponse = suceess.toDTO()
                return .success(chatResponse)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
