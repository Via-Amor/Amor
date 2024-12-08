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
    
    func fetchDMList(request: DMRoomRequestDTO) -> RxSwift.Single<Result<[DMRoomResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.getDMList(request: request), response: [DMRoomResponseDTO].self)
    }
    
    func fetchDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody) -> RxSwift.Single<Result<DMRoomResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.getDMRoom(request: request, body: body), response: DMRoomResponseDTO.self)
    }
    
    func fetchChatList(requestDTO: ChatRequestDTO) -> Single<Result<[ChatResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.getDMChatList(request: requestDTO), response: [DMChatResponseDTO].self)
            .map { result -> Result<[ChatResponseDTO], NetworkError> in
            switch result {
            case .success(let suceess):
                let chatResponses: [ChatResponseDTO] = suceess.map { $0.toDTO() }
                return .success(chatResponses)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    func postChat(requestDTO: ChatRequestDTO, bodyDTO: ChatRequestBodyDTO) -> Single<Result<ChatResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.postDMChat(request: requestDTO, body: bodyDTO), response: DMChatResponseDTO.self)
            .map { result -> Result<ChatResponseDTO, NetworkError> in
            switch result {
            case .success(let suceess):
                let chatResponse: ChatResponseDTO = suceess.toDTO()
                return .success(chatResponse)
            case .failure(let error):
                return .failure(error)
            }
        }
    }
}
