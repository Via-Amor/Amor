//
//  SearchChannelViewModel.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchChannelViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input) -> Output {
        input.viewWillAppearTrigger
            .bind(with: self) { owner, _ in
                print("HI")
            }
            .disposed(by: disposeBag)
        return Output()
    }
}
