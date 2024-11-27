//
//  DMViewRepository.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

protocol DMRepository {
    func fetchDMRooms(request: DMRoomRequestDTO) -> Single<Result<[DMRoomResponseDTO], NetworkError>>
}
