//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class HomeViewController: BaseVC<HomeView> {
    var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleLabel)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func bind() {
        let trigger = PublishSubject<Void>()
        let section = PublishSubject<Int>()
        let input = HomeViewModel.Input(trigger: trigger, section: section)
        let output = viewModel.transform(input)
        
        output.myProfileImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
            }
            .disposed(by: disposeBag)
        
        output.noSpace
            .bind(with: self) { owner, value in
                print(value)
                if value {
                    owner.baseView.navBar.configureNavTitle(.home("No Space"))
                }
                owner.baseView.showEmptyView(show: value)
            }
            .disposed(by: disposeBag)
        
        output.spaceInfo
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureNavTitle(.home(value.name))
                owner.baseView.navBar.configureSpaceImageView(image: value.coverImage)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            
            switch item {
            case .myChannelItem(let data), .dmRoomItem(let data):
                cell.configureCell(image: data.image, name: data.name, messageCount: nil)
                cell.addDivider(isVidsble: data.image == "PlusMark" || dataSource.sectionModels.isEmpty)
            case .addMember(let data):
                cell.configureCell(image: data.image, name: data.name, messageCount: nil)
                cell.addDivider(isVidsble: false)
            }
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
            
            headerView.configureHeaderView(item: dataSource.sectionModels[indexPath.section])
            headerView.buttonClicked()
                .map({ dataSource.sectionModels[indexPath.section].section })
                .bind(to: section)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
        
        output.dataSource
            .bind(to: baseView.homeCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        baseView.homeCollectionView.rx.modelSelected(HomeSectionItem.self)
            .bind(with: self) { owner, value in
                switch value {
                case .myChannelItem(let value):
                    print(value)
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.navigationBar.tintColor = .black
                    owner.coordinator?.showChatFlow()
                    break
                case .dmRoomItem(let value):
                    if value.image == "PlusMark" {
                        if let tabBarController = owner.tabBarController {
                            tabBarController.selectedIndex = 1
                        }
                    } else {
                        
                    }
                case .addMember(let value):
                    break
                }
            }
            .disposed(by: disposeBag)
        
        baseView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                if let tabBarController = owner.tabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
            .disposed(by: disposeBag)
        
        trigger.onNext(())
    }
}
