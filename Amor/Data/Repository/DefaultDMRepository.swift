//
//  DMViewRepositorylmpl.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

final class DefaultDMRepository: DMRepository {
    private let networkManager: NetworkType
    private let disposeBag = DisposeBag()
    
    init(_ networkManager: NetworkType) {
        self.networkManager = networkManager
    }
    
    func fetchDMRoomList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoomResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: DMTarget.getDMList(request: request),
            response: [DMRoomResponseDTO].self
        )
    }
    
    func makeDMRoom(
        request: DMRoomRequestDTO,
        body: DMRoomRequestDTOBody
    )
    -> Single<Result<DMRoomResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: DMTarget.getDMRoom(request: request, body: body),
            response: DMRoomResponseDTO.self
        )
    }
    
    func postChat(
        path: ChatRequestDTO,
        body: ChatRequestBodyDTO
    )
    -> Single<Result<ChatResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: DMTarget.postDMChat(
                path: path,
                body: body
            ),
            response: DMChatResponseDTO.self
        )
        .map { result in
            switch result {
            case .success(let suceess):
                let chatResponse = suceess.toDTO()
                return .success(chatResponse)
            case .failure(let error):
                return .failure(error)
            }
        }
    }

    
    func fetchServerDMChatList(request: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: DMTarget.getDMChatList(request: request),
            response: [DMChatResponseDTO].self
        ).map { result in
            switch result {
            case .success(let suceess):
                let chatResponses = suceess.map { $0.toDTO() }
                return .success(chatResponses)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func fetchUnreadDMCount(request: UnreadDMRequstDTO)
    -> Single<Result<UnreadDMResponseDTO, NetworkError>> {
        return networkManager.callNetwork(
            target: DMTarget.getUnreadDMs(request: request),
            response: UnreadDMResponseDTO.self
        )
    }
}
