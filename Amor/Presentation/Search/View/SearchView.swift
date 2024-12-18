//
//  SearchView.swift
//  Amor
//
//  Created by 홍정민 on 12/1/24.
//

import UIKit
import SnapKit

final class SearchView: BaseView {
    private let divider = DividerView()
    lazy var searchResultCollectionView = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: .setHomeCollectionViewLayout()
        )
        cv.isScrollEnabled = true
        
        return cv
    }()

    private let searchLabel = UILabel()
    private let searchImageView = UIImageView()
    
    override func configureHierarchy() {
        addSubview(divider)
        addSubview(searchResultCollectionView)
        addSubview(searchLabel)
        addSubview(searchImageView)
    }
    
    override func configureLayout() {
        divider.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.top.equalTo(searchImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    override func configureView() {
        searchLabel.text = "채널, 멤버를 검색해보세요!"
        searchLabel.font = .title2
        searchLabel.textColor = .themeInactive
        searchLabel.textAlignment = .center
        
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        searchImageView.tintColor = .themeInactive
        
        searchResultCollectionView.register(
            HomeCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier
        )
        
        searchResultCollectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.identifier
        )
    }
    
    func showSearchView() {
        searchLabel.isHidden = false
        searchLabel.text = "채널, 멤버를 검색해보세요!"
        
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        searchImageView.isHidden = false
        
        searchResultCollectionView.isHidden = true
    }
    
    func showResultView(isEmpty: Bool) {
        searchLabel.isHidden = !isEmpty
        searchLabel.text = "검색 결과가 없습니다."
        
        searchImageView.image = UIImage(systemName: "text.badge.xmark")
        searchImageView.isHidden = !isEmpty
        
        searchResultCollectionView.isHidden = isEmpty
    }
    
    func showEmptySearchText() {
        searchLabel.text = "공백 없이 한글자 이상 입력해주세요."
        
        searchImageView.image = UIImage(systemName: "exclamationmark.magnifyingglass")
        searchResultCollectionView.isHidden = true
    }
}
