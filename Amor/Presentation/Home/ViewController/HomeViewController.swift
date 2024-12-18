//
//  ViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import Toast

final class HomeViewController: BaseVC<HomeView> {
    var coordinator: HomeCoordinator?
    private let viewModel: HomeViewModel
    
    private let fetchHome = PublishRelay<Void>()
    private let showToast = PublishRelay<String>()
    let fetchHomeDefaultTrigger = BehaviorRelay<Void>(value: ())
    let updateChannelTrigger = PublishRelay<Void>()
    let updateChannelValueTrigger = PublishRelay<[Channel]>()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItems = [
            .init(customView: baseView.navBar.spaceImageView),
            .init(customView: baseView.navBar.spaceTitleButton)
        ]
        
        navigationItem.rightBarButtonItem = .init(
            customView: baseView.navBar.myProfileButton
        )
    }
    
    override func bind() {
        let toggleSection = PublishRelay<Int>()
        let input = HomeViewModel.Input(
            fetchHomeDefaultTrigger: fetchHomeDefaultTrigger,
            updateChannelTrigger: updateChannelTrigger,
            updateChannelValueTrigger: updateChannelValueTrigger,
            toggleSection: toggleSection,
            fetchHome: fetchHome,
            showToast: showToast
        )
        let output = viewModel.transform(input)
        
        output.myProfileImage
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureMyProfileImageView(image: value)
                owner.baseView.showEmptyView(show: false)
            }
            .disposed(by: disposeBag)
        
        output.noSpace
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureNavTitle(
                    Navigation.Space.noSpace.title
                )
                owner.baseView.showEmptyView(show: true)
            }
            .disposed(by: disposeBag)
        
        output.spaceInfo
            .compactMap { $0 }
            .bind(with: self) { owner, value in
                owner.baseView.navBar.configureNavTitle(
                    Navigation.Space.home(spaceName: value.name).title
                )
                owner.baseView.navBar.configureSpaceImageView(image: value.coverImage)
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            
            switch item {
            case .myChannelItem(let data):
                cell.configureCell(image: UIImage(resource: .hashtagLight), name: data.channelName, messageCount: data.unreadCount)
                cell.addDivider(isVidsble: dataSource.sectionModels[indexPath.section].items.isEmpty)
            case .dmRoomItem(let data):
                cell.configureCell(
                    image: data.opponentProfile,
                    name: data.opponentName,
                    messageCount: data.unreadCount
                )
                cell.addDivider(isVidsble: dataSource.sectionModels[indexPath.section].items.isEmpty)
            case .add(let data):
                cell.configureCell(image: UIImage(resource: .plusMark), name: data, messageCount: nil)
                cell.addDivider(isVidsble: true)
            }
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
            
            headerView.configureHeaderView(item: dataSource.sectionModels[indexPath.section])
            headerView.buttonClicked()
                .map({ dataSource.sectionModels[indexPath.section].section })
                .bind(to: toggleSection)
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
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.navigationBar.tintColor = .black
                    let channel = Channel(
                        channel_id: channel.channelID,
                        name: channel.channelName,
                        description: "",
                        coverImage: "",
                        owner_id: ""
                    )
                    owner.coordinator?.showChatFlow(channel: channel)
                    break
                case .dmRoomItem(let dmRoomInfo):
                    owner.navigationItem.backButtonTitle = ""
                    owner.navigationController?.navigationBar.tintColor = .black
                    let dmRoomInfo = DMRoomInfo(
                        room_id: dmRoomInfo.roomID,
                        roomName: dmRoomInfo.opponentName,
                        profileImage: dmRoomInfo.opponentProfile,
                        content: "",
                        createdAt: "",
                        files: []
                    )
                    owner.coordinator?.showChatFlow(dmRoomInfo: dmRoomInfo)
                    break
                case .add:
                    switch value.0.section {
                    case 0:
                        owner.showChannelActionSheet()
                    case 1:
                        owner.coordinator?.showDMTabFlow()
                    case 2:
                        if let ownerId = output.spaceInfo.value?.owner_id {
                            if UserDefaultsStorage.userId == ownerId {
                                let vc = AddMemberViewController(viewModel: AddMemberViewModel(useCase: DefaultSpaceUseCase(spaceRepository: DefaultSpaceRepository(NetworkManager.shared))))
                                vc.delegate = self
                                let nav = UINavigationController(rootViewController: vc)
                                owner.present(nav, animated: true)
                            } else {
                                owner.view.makeToast(ToastText.inviteMemberUnabled)
                            }
                        }
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
                    owner.fetchHome.accept(())
                    owner.coordinator?.dismissSideSpaceMenuFlow()
                }
                .disposed(by: disposeBag)
        }
        
        output.backLoginView
            .bind(with: self) { owner, _ in
                owner.coordinator?.showLoginFlow()
            }
            .disposed(by: disposeBag)
        
        output.toastMessage
            .bind(with: self) { owner, value in
                owner.baseView.makeToast(value)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func showChannelActionSheet() {
        let channelActionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let addChannelAction = UIAlertAction(
            title:ActionSheetText.ChannelActionSheetText.add.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.coordinator?.showAddChannelFlow()
        }
        
        let searchChannelAction = UIAlertAction(
            title: ActionSheetText.ChannelActionSheetText.search.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.coordinator?.showSearchChannelFlow()
        }
        
        let cancelAction = UIAlertAction(
            title: ActionSheetText.ChannelActionSheetText.cancel.rawValue,
            style: .cancel,
            handler: nil
        )
        
        channelActionSheet.addAction(addChannelAction)
        channelActionSheet.addAction(searchChannelAction)
        channelActionSheet.addAction(cancelAction)

        present(channelActionSheet, animated: true, completion: nil)
    }
}

extension HomeViewController: AddChannelDelegate {
    func didAddChannel() {
        updateChannelTrigger.accept(())
    }
}

extension HomeViewController: AddMemberDelegate {
    func didAddMember() {
        dismiss(animated: true)
        showToast.accept(ToastText.addMemberSuccess)
    }
}

extension HomeViewController: SideSpaceMenuDelegate {
    func updateSpace() {
        fetchHomeDefaultTrigger.accept(())
    }
    
    func updateHomeAndSpace() {
        coordinator?.dismissSideSpaceMenuFlow()
        fetchHomeDefaultTrigger.accept(())
    }
}
