//
//  ChannelSettingViewController.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChannelSettingViewController: BaseVC<ChannelSettingView> {
    var coordinator: ChatCoordinator?
    let viewModel: ChannelSettingViewModel
    
    init(viewModel: ChannelSettingViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = ChannelSettingViewModel.Input(
            viewWillAppearTrigger: rx.methodInvoked(#selector(viewWillAppear))
                .map { _ in },
            editChannelTap: baseView.editButton.rx.tap
        )
        let output = viewModel.transform(input)

        let dataSource = dataSource()
        
        output.channelInfo
            .drive(with: self) { owner, data in
                owner.baseView.configureData(data: data)
            }
            .disposed(by: disposeBag)
        
        output.memberSection
            .drive(baseView.memberCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isAdmin
            .filter { !$0 }
            .emit(with: self) { owner, isAdmin in
                owner.baseView.hideAdminButton()
            }
            .disposed(by: disposeBag)

        output.presentErrorToast
            .emit(with: self) { owner, toastText in
                owner.baseView.makeToast(toastText)
            }
            .disposed(by: disposeBag)
        
        
        output.presentEditChannel
            .emit(with: self) { owner, channelID in
                owner.coordinator?.showEditChannel(channelID: channelID)
            }
            .disposed(by: disposeBag)
        rx.methodInvoked(#selector(viewDidLayoutSubviews))
            .map { _ in }
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self) { owner, _ in
                owner.updateCollectionViewHeight()
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.channelSetting
    }
}

extension ChannelSettingViewController {
    private func updateCollectionViewHeight() {
        let contentSize = baseView.memberCollectionView.contentSize.height
        if contentSize > 0 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.baseView.memberCollectionView.snp.updateConstraints { make in
                    make.height.equalTo(contentSize)
                }
            }
        }
    }
    
    private func removeCollectionViewHeight() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.baseView.memberCollectionView.snp.updateConstraints { make in
                make.height.equalTo(50)
            }
        }
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<ChannelSettingSectionModel> {
        return RxCollectionViewSectionedReloadDataSource {
            dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ChannelSettingCollectionViewCell.identifier,
                for: indexPath
            ) as? ChannelSettingCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureData(data: item)
            return cell
        } configureSupplementaryView: {
            dataSource, collectionView, elementKind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: HomeCollectionHeaderView.identifier,
                for: indexPath
            ) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
            let header = dataSource[indexPath.section].header
            headerView.configureHeaderText(text: header)
            headerView.openStatusButton.rx.tap
                .asDriver()
                .throttle(.seconds(1))
                .map { headerView.isOpenUp }
                .drive(with: self) { owner, isOpen in
                    if isOpen {
                        owner.removeCollectionViewHeight()
                    } else {
                        owner.updateCollectionViewHeight()
                    }
                    
                    headerView.isOpenUp.toggle()
                }
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
        
    }
    
}
