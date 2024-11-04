//
//  DMViewRepositorylmpl.swift
//  Amor
//
//  Created by 김상규 on 11/3/24.
//

import Foundation
import RxSwift

final class DMViewRepositorylmpl: DMViewRepository {
    
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
    
    func fetchSpaceMembers(spaceID: String, completionHandler: @escaping (Result<[DMSpaceMemberDTO], NetworkError>) -> Void) {
        let query = DMMembersRequestDTO(workspace_id: spaceID)
        networkManager.callNetwork(target: DMTarget.getWorkSpaceMember(query: query), response: [DMSpaceMemberDTO].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchSpaceMembers error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchDMRooms(spaceID: String, completionHandler: @escaping (Result<[DMRoomResponseDTO], NetworkError>) -> Void) {
        let query = DMRoomRequestDTO(workspace_id: spaceID)
        networkManager.callNetwork(target: DMTarget.getDMRooms(query: query), response: [DMRoomResponseDTO].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let success):
                    completionHandler(.success(success))
                case .failure(let error):
                    print("fetchDMRooms error", error)
                    completionHandler(.failure(error))
                }
            }
            .disposed(by: disposeBag)
    }
}
