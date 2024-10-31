//
//  DMViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DMViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let userArray: BehaviorSubject<[Int]>
        let chatArray: BehaviorSubject<[Int]>
    }
    
    func transform(_ input: Input) -> Output {
        let userArray = BehaviorSubject<[Int]>(value: [])
        let chatArray = BehaviorSubject<[Int]>(value: [])
        
        input.trigger
            .bind(with: self) { owner, _ in
                userArray.onNext([1,2,3,4,5,6,7,8,9,10])
                chatArray.onNext([1,2,3,4,5,6,7,8,9,10])
            }
            .disposed(by: disposeBag)
        
        
        return Output(userArray: userArray, chatArray: chatArray)
    }
}
