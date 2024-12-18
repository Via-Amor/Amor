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
