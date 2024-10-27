//
//  DMView.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit

final class DMView: BaseView {
    let wsImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .orange
        
        return imageView
    }()
    let wsTitleLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    let profileImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .yellow
        
        return imageView
    }()
    let dividerLine = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        return view
    }()
    lazy var dmUserCollectionView = {
        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.user))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        
        return cv
    }()
    let dividerLine2 =  {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        return view
    }()
    lazy var dmChatCollectionView = {
        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.chat))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        
        return cv
    }()
    override func configureHierarchy() {
        addSubview(dividerLine)
        addSubview(dmUserCollectionView)
        addSubview(dividerLine2)
        addSubview(dmChatCollectionView)
    }
    
    override func configureLayout() {
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmUserCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(90)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(dmUserCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmChatCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setDmCollectionViewLayout(_ type: DMCollectionViewType) -> UICollectionViewLayout {
        
        let layout: UICollectionViewLayout
        
        switch type {
        case .user:
            layout = setDMUserCollectionViewLayout()
        case .chat:
            layout = setDMChatCollectionViewLayout()
        }
        
        return layout
    }
    
    private func setDMUserCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .fractionalHeight(1)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setDMChatCollectionViewLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.showsSeparators = false
        listConfiguration.separatorConfiguration.bottomSeparatorInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        return layout
    }
}
