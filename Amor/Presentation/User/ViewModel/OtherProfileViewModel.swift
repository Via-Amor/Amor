//
//  OtherProfileViewModel.swift
//  Amor
//
//  Created by 김상규 on 12/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class OtherProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let otherProfile: SpaceMember
    
    init(otherProfile: SpaceMember) {
        self.otherProfile = otherProfile
    }
    
    struct Input {
        let viewWillTrigger: Observable<Void>
    }
    
    struct Output {
        let otherProfileImage: PublishSubject<String?>
        let dataSource: BehaviorRelay<[ProfileSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let otherProfile = PublishRelay<SpaceMember>()
        let dataSource = BehaviorRelay<[ProfileSectionModel]>(value: [])
        let otherProfileImage = PublishSubject<String?>()
        
        input.viewWillTrigger
            .map { _ in
                self.otherProfile
            }
            .bind(to: otherProfile)
            .disposed(by: disposeBag)
            
        
        otherProfile
            .bind(with: self) { owner, value in
                let data = [ProfileSectionModel.isStatic(
                    items: [ProfileSectionItem.isStaticItem(
                        ProfileItem(
                            profile: .nickname,
                            value: value.nickname)
                    ),
                            ProfileSectionItem.isStaticItem(
                        ProfileItem(
                            profile: .email,
                            value: value.email)
                    )]
                )]
                
                
                dataSource.accept(data)
                otherProfileImage.onNext(value.profileImage)
            }
            .disposed(by: disposeBag)
        
        return Output(otherProfileImage: otherProfileImage, dataSource: dataSource)
    }
}
