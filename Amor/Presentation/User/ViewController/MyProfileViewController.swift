//
//  MyProfileViewController.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import RxSwift
import RxDataSources

final class MyProfileViewController: BaseVC<MyProfileView> {
    let viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemGroupedBackground
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.User.editProfile
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronLeft,
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    override func bind() {
        let input = MyProfileViewModel.Input(trigger: BehaviorSubject(value: ()))
        let output = viewModel.transform(input)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ProfileSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
            
            switch item {
            case .profileImageItem(let profile):
                cell.configureCell(element: profile.profileElement, profile: profile.value)
            case .canChangeItem(let profile):
                cell.configureCell(element: profile.profileElement, profile: profile.value)
                cell.backgroundColor = .tertiarySystemBackground
            case .isStaticItem(let profile):
                cell.configureCell(element: profile.profileElement, profile: profile.value)
                cell.backgroundColor = .tertiarySystemBackground
            }
            
            return cell
        }
        
        output.profileSectionModels
            .bind(to: baseView.profileCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        baseView.profileCollectionView.rx.modelSelected(ProfileSectionModel.Item.self)
            .bind(with: self) { owner, value in
                switch value {
                case .canChangeItem(let profile):
                    switch profile.profileElement {
                    case .sesacCoin:
                        break
                    case .nickname, .phone:
                        let vc = EditProfileViewController(element: profile)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    default:
                        break
                    }
                case .isStaticItem(let profile):
                    if profile.profileElement.elementName == "로그아웃" {
                        print(profile)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
