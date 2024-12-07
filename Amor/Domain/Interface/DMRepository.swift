//
//  DMViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMRepository: ChatRepository {
    func fetchDMList(request: DMRoomRequestDTO)
    -> Single<Result<[DMRoomResponseDTO], NetworkError>>
    func fetchDMRoom(request: DMRoomRequestDTO, body: DMRoomRequestDTOBody)
    -> Single<Result<DMRoomResponseDTO, NetworkError>>
}
