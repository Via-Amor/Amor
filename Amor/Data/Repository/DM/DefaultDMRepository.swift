//
//  DMViewRepositorylmpl.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

final class DefaultDMRepository: DMRepository {
    
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    func fetchDMRooms(request: DMRoomRequestDTO) -> RxSwift.Single<Result<[DMRoomResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.getDMRooms(request: request), response: [DMRoomResponseDTO].self)
    }
}
