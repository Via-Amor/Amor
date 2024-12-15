//
//  OtherProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class OtherProfileViewController: BaseVC<OtherProfileView> {
    
    let viewModel: OtherProfileViewModel
    
    init(viewModel: OtherProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.User.profile
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    override func bind() {
        let input = OtherProfileViewModel.Input(
            viewWillTrigger: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }
        )
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherProfileCollectionViewCell.identifier, for: indexPath) as? OtherProfileCollectionViewCell else { return UICollectionViewCell() }
            
            switch item {
            case .isStaticItem(let data):
                cell.configureCell(profile: data.profile.name, value: data.value ?? "")
            default:
                break
            }
            
            return cell
            
        }
        
        output.otherProfileImage
            .bind(with: self) { owner, image in
                owner.baseView.setOtherProfileImage(image: image)
            }
            .disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: baseView.otherProfileCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

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
                
                print(data)
                
                dataSource.accept(data)
                otherProfileImage.onNext(value.profileImage)
            }
            .disposed(by: disposeBag)
        
        return Output(otherProfileImage: otherProfileImage, dataSource: dataSource)
    }
}
