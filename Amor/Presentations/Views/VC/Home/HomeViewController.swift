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
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
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
            
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
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
        
        trigger.onNext(())
    }
}
