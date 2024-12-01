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
    
    func fetchDMRooms(request: DMRoomRequestDTO) -> RxSwift.Single<Result<[DMRoomResponseDTO], NetworkError>> {
        return networkManager.callNetwork(target: DMTarget.getDMRooms(request: request), response: [DMRoomResponseDTO].self)
    }
}
