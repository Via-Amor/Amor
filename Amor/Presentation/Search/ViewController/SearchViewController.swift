//
//  SearchViewController.swift
//  Amor
//
//  Created by 양승혜 on 10/23/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: BaseVC<SearchView> {
    private let viewModel = SearchViewModel(useCase: DefaultSpaceUseCase(spaceRepository: DefaultSpaceRepository(NetworkManager.shared)))
    
    override func configureNavigationBar() {
        navigationItem.title = "스페이스 내 검색"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.placeholder = "채널, 멤버를 검색해보세요!"
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.automaticallyShowsCancelButton = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
   
    override func bind() {
        let section = PublishSubject<Int>()
        let string = PublishSubject<String>()
        let buttonTap = PublishRelay<Void>()
        let input = SearchViewModel.Input(searchText: string, searchButtonTap: buttonTap, section: section)
        let output = viewModel.transform(input)
        
        navigationItem.searchController?.searchBar.rx.searchButtonClicked
            .bind(to: buttonTap)
            .disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.text.orEmpty
            .bind(to: string)
            .disposed(by: disposeBag)
        
        navigationItem.searchController?.searchBar.rx.cancelButtonClicked
            .bind(with: self) { owner, _ in
                owner.baseView.showSearchView()
            }
            .disposed(by: disposeBag)
        
        output.showSearchView
            .bind(with: self) { owner, _ in
                owner.baseView.showSearchView()
            }
            .disposed(by: disposeBag)
        
        output.showEmptySearchText
            .bind(with: self) { owner, _ in
                owner.baseView.showEmptySearchText()
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SearchSectionModel> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            
            let sectionItems = dataSource.sectionModels[indexPath.section].items
            let isLastItem = indexPath.row == sectionItems.count - 1
            let isSectionEmpty = sectionItems.isEmpty
            
            switch item {
            case .channelItem(let data):
                cell.configureCell(image: UIImage(resource: .hashtagLight), name: data.name, messageCount: nil)
            case .memberItem(let data):
                cell.configureCell(image: data.profileImage, name: data.nickname, messageCount: nil)
            }
            
            if isSectionEmpty || isLastItem {
                cell.addDivider(isVisable: true)
            } else {
                cell.addDivider(isVisable: false)
            }
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeCollectionHeaderView.identifier, for: indexPath) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
            
            headerView.configureHeaderView(item: dataSource.sectionModels[indexPath.section])
            headerView.buttonClicked()
                .map {
                    return dataSource.sectionModels[indexPath.section].section
                }
                .bind(to: section)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
        
        output.searchResult
            .bind(to: baseView.searchResultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.showResultView
            .bind(with: self) { owner, value in
                print(value)
                owner.baseView.showResultView(isEmpty: value)
            }
            .disposed(by: disposeBag)
    }
}
