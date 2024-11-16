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
        let input = HomeViewModel.Input(trigger: trigger)
        let output = viewModel.transform(input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            
            switch item {
            case .myChannelItem(let data), .dmRoomItem(let data), .addMember(let data):
                cell.configureCell(image: data.image, name: data.name, messageCount: nil)
            }
            
            if indexPath.item == dataSource.sectionModels[indexPath.section].items.count - 1 {
                switch item {
                case .addMember:
                    cell.addDivider(isVidsble: false)
                default:
                    cell.addDivider(isVidsble: true)
                }
            }
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
            
            headerView.configureHeaderView(header: dataSource.sectionModels[indexPath.section].header)
            
            return headerView
        }
        
        
        output.dataSource
            .bind(to: baseView.homeCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
            
        
        trigger.onNext(())
    }
}
