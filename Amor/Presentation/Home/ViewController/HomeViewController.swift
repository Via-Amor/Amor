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
import RxGesture

final class HomeViewController: BaseVC<HomeView> {
    var coordinator: HomeCoordinator?
    
    private let viewModel: HomeViewModel
    private let fetchChannel = PublishSubject<Void>()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [.init(customView: baseView.navBar.spaceImageView), .init(customView: baseView.navBar.spaceTitleButton)]
        
        navigationItem.rightBarButtonItem = .init(customView: baseView.navBar.myProfileButton)
    }
    
    override func bind() {
        let trigger = BehaviorSubject<Void>(value: ())
        let section = PublishSubject<Int>()
        let input = HomeViewModel.Input(trigger: trigger, section: section, fetchChannel: fetchChannel)
        let output = viewModel.transform(input)
        
        output.myProfileImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
                owner.baseView.showEmptyView(show: false)
            }
            .disposed(by: disposeBag)
        
        output.noSpace
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureNavTitle(.home("No Space"))
                owner.baseView.showEmptyView(show: true)
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
            case .myChannelItem(let data):
                cell.configureCell(image: Design.Icon.hashtagLight, name: data.name, messageCount: nil)
                cell.addDivider(isVidsble: dataSource.sectionModels[indexPath.section].items.isEmpty)
            case .dmRoomItem(let data):
                cell.configureCell(image: data.user.profileImage, name: data.user.nickname, messageCount: nil)
                cell.addDivider(isVidsble: dataSource.sectionModels[indexPath.section].items.isEmpty)
            case .add(let data):
                cell.configureCell(image: Design.Icon.plus, name: data, messageCount: nil)
                cell.addDivider(isVidsble: true)
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
        
        Observable.zip(baseView.homeCollectionView.rx.itemSelected, baseView.homeCollectionView.rx.modelSelected(HomeSectionItem.self))
            .bind(with: self) { owner, value in
                 
                switch value.1 {
                case .myChannelItem(let channel):
                    print(channel.channel_id)
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.navigationBar.tintColor = .black
                    owner.coordinator?.showChatFlow(channel: channel)
                    break
                case .dmRoomItem(let dmRoom):
                    print(dmRoom.user.user_id)
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.navigationBar.tintColor = .black
//                    owner.coordinator?.showChatFlow(chatId: dmRoom)
                    break
                case .add:
                    switch value.0.section {
                    case 0:
                        owner.showActionSheet()
                    case 1:
                        owner.coordinator?.showDMTabFlow()
                    case 2:
                        break
                    default:
                        break
                    }
                }
            }
            .disposed(by: disposeBag)
        
        baseView.floatingButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.showDMTabFlow()
            }
            .disposed(by: disposeBag)

        baseView.navBar.spaceTitleButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator?.presentSideMenuFlow()
            }
            .disposed(by: disposeBag)
        
        if let coordinator = self.coordinator?.parentCoordinator as? TabCoordinator {
            coordinator.tabBarController.dimmingView.rx.tapGesture()
                .bind(with: self) { owner, _ in
                    owner.coordinator?.dismissSideMenuFlow()
                }
                .disposed(by: disposeBag)
        }
        
        output.backLoginView
            .bind(with: self) { owner, _ in
                owner.coordinator?.showLoginFlow()
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "채널 추가", style: .default, handler: { [weak self] _ in
            self?.coordinator?.showAddChannelFlow()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "채널 탐색", style: .default, handler: { [weak self] _ in
            let nav = UINavigationController(rootViewController: UIViewController())
            self?.present(nav, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension HomeViewController: AddChannelDelegate {
    func didAddChannel() {
        fetchChannel.onNext(())
    }
}

extension HomeViewController: SideSpaceMenuDelegate {
    func updateSpace(spaceSimpleInfo: SpaceSimpleInfo) {
        baseView.navBar.configureNavTitle(.home(spaceSimpleInfo.name))
        baseView.navBar.configureSpaceImageView(image: spaceSimpleInfo.coverImage)
    }
}
