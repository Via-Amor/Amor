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
    
    // 내가 속한 채널 리스트 조회
    func fetchChannels(request: ChannelRequestDTO)
    -> Single<Result<[ChannelResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getMyChannels(query: request),
            response: [ChannelResponseDTO].self
        )
    }
    
    // 특정 채널 정보 조회
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
    
    // 채널 추가
    func addChannel(
        path: ChannelRequestDTO,
        body: AddChannelRequestDTO
    ) -> Single<Result<ChannelResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.addChannel(path: path, body: body),
            response: ChannelResponseDTO.self)
    }
    
    // 채널 수정
    func editChannel(
        path: ChannelRequestDTO,
        body: EditChannelRequestDTO
    ) -> Single<Result<ChannelResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.editChannel(path: path, body: body),
            response: ChannelResponseDTO.self
        )
    }
    
    // 채널 삭제
    func deleteChannel(
        path: ChannelRequestDTO
    ) -> Single<Result<EmptyResponseDTO, NetworkError>> {
        return networkManager.callNetworkEmptyResponse(
            target: ChannelTarget.deleteChannel(path: path))
    }
}

extension DefaultChannelRepository {
    // 채팅 내역 조회
    func fetchChatList(requestDTO: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getChannelChatList(request: requestDTO),
            response: [ChatResponseDTO].self)
    }
    
    // 채팅 전송
    func postChat(requestDTO: ChatRequestDTO, bodyDTO: ChatRequestBodyDTO)
    -> Single<Result<ChatResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.postChannelChat(request: requestDTO, body: bodyDTO),
            response: ChatResponseDTO.self
        )
    }
}
