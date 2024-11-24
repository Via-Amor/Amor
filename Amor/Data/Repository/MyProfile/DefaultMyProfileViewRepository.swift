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
    
    func fetchMyProfile(completionHandler: @escaping (Result<MyProfileResponseDTO, NetworkError>) -> Void ) {
        networkManager.callNetwork(target: MyProfileTarget.getMyProfile, response: MyProfileResponseDTO.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchMyProfile error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
}
