//
//  DMViewUseCase.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMUseCase {
    func getDMList(request: DMRoomRequestDTO) 
    -> Single<Result<[DMRoom], NetworkError>>
    func getDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody)
    -> Single<Result<DMRoom, NetworkError>>
}

final class DefaultDMUseCase: DMUseCase {
    private let dmRepository: DMRepository
    
    init(dmRepository: DMRepository) {
        self.dmRepository = dmRepository
    }
    
    func getDMList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoom], NetworkError>> {
        dmRepository.fetchDMList(request: request)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.map({ $0.toDomain() })))
                case .failure(let error):
                    print("getDMRooms error", error)
                    return .just(.failure(error))
                }
            }
    }
    
    func getDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody) -> RxSwift.Single<Result<DMRoom, NetworkError>> {
        dmRepository.fetchDMRoom(request: request, body: body)
            .flatMap{ result in
                switch result {
                case .success(let success):
                    return .just(.success(success.toDomain()))
                case .failure(let error):
                    print("getDMRoom error", error)
                    return .just(.failure(error))
                }
            }
    }
}
