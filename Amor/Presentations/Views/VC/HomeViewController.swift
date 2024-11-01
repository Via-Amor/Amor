//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift

class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let validEmailDTO = ValidEmailRequestDTO(email: "sesac@sesac.com")
        NetworkManager.shared.callNetwork(
            target: UserTarget.validEmail(
                body: validEmailDTO
            ),
            response: EmptyResponse.self
        )
        .subscribe(with: self) { owner, result in
            print(result)
        }
        .disposed(by: disposeBag)

    }
}
