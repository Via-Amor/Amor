//
//  MyProfileViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import Foundation
import RxSwift

final class MyProfileViewModel: BaseViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: UserUseCase
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    struct Input {
        let trigger: BehaviorSubject<Void>
    }
    
    struct Output {
        let profileSectionModels: BehaviorSubject<[ProfileSectionModel]>
    }
    
    func transform(_ input: Input) -> Output {
        let myProfile = PublishSubject<[ProfileItem]>()
        let profileSectionModels = BehaviorSubject<[ProfileSectionModel]>(value: [])
        
        input.trigger
            .flatMap({ self.useCase.getMyProfile() })
            .bind(with: self) { owner, result in
                switch result {
                case .success(let profile):
                    var result: [ProfileItem] = []
                    
                    for i in Profile.allCases {
                        switch i {
                        case .profileImage:
                            result.append(ProfileItem(profile: .profileImage, value: profile.profileImage))
                        case .sesacCoin:
                            result.append(ProfileItem(profile: .sesacCoin, value: "\(profile.sesacCoin)"))
                        case .nickname:
                            result.append(ProfileItem(profile: .nickname, value: profile.nickname))
                        case .phone:
                            result.append(ProfileItem(profile: .phone, value: profile.phone))
                        case .email:
                            result.append(ProfileItem(profile: .email, value: profile.email))
                        case .provider:
                            if let _ = profile.provider {
                                result.append(ProfileItem(profile: .provider, value: profile.provider))
                            } else {
                                break
                            }
                        case .logOut:
                            result.append(ProfileItem(profile: .logOut, value: i.name))
                        }
                    }
                    
                    myProfile.onNext(result)
                    
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        myProfile
            .map({ value -> [ProfileSectionModel] in
                var profileImageItem: [ProfileSectionItem] = []
                var canChangeItems: [ProfileSectionItem] = []
                var isStaticItems: [ProfileSectionItem] = []
                for i in value {
                    let item: ProfileSectionItem
                    
                    switch i.profile {
                    case .profileImage:
                        item = .profileImageItem(i)
                        profileImageItem.append(item)
                    case .sesacCoin, .nickname, .phone:
                        item = .canChangeItem(i)
                        canChangeItems.append(item)
                    case .email, .provider, .logOut:
                        item = .isStaticItem(i)
                        isStaticItems.append(item)
                    }
                }
                
                return [ProfileSectionModel.profileImage(items: profileImageItem), ProfileSectionModel.canChange(items: canChangeItems), ProfileSectionModel.isStatic(items: isStaticItems)]
            })
            .bind(with: self) { owner, value in
                profileSectionModels.onNext(value)
                print(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(profileSectionModels: profileSectionModels)
    }
}
