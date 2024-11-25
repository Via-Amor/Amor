//
//  DefaultHomeRepository.swift
//  Amor
//
//  Created by 김상규 on 11/14/24.
//

import Foundation
import RxSwift

final class DefaultChannelRepository: ChannelRepository {
    
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    func fetchLogin(completionHandler: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void ) {
        let loginDto = LoginRequestDTO(email: "qwe123@gmail.com", password: "Qwer1234!")
        
        networkManager.callNetwork(target: DMTarget.login(body: loginDto), response: LoginResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchLogin error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchChannels(spaceID: String, completionHandler: @escaping (Result<[ChannelResponseDTO], NetworkError>) -> Void) {
        let query = ChannelRequestDTO()
        print(query.workspaceId)
        networkManager.callNetwork(target: ChannelTarget.getMyChannels(query: query), response: [ChannelResponseDTO].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchChannels error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
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
    
}

extension DefaultChannelRepository {
    // 채팅 내역 조회
    func fetchChannelChatList(requestDTO: ChatRequestDTO)
    -> Single<Result<[ChatResponseDTO], NetworkError>> {
        return networkManager.callNetwork(
            target: ChannelTarget.getChannelChatList(request: requestDTO),
            response: [ChatResponseDTO].self)
    }
}
