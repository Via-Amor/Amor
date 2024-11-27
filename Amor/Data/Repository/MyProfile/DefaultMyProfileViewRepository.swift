//
//  MyProfileViewRepositorylmpl.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

final class DefaultMyProfileViewRepository: MyProfileRepository {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    func fetchMyProfile() -> Single<Result<MyProfileResponseDTO, NetworkError>> {
        return networkManager.callNetwork(target: MyProfileTarget.getMyProfile, response: MyProfileResponseDTO.self)
    }
}
