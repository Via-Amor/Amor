//
//  DMView.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit

final class DMView: BaseView {
    let spaceImageView = RoundImageView()
    let spaceTitleLabel = {
        let label = UILabel()
        label.text = "Direct Message"
        label.font = .Size.title1
        
        return label
    }()
    
    let myProfileButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemPink
        button.configuration = configuration
        
        return button
    }()
    let dividerLine = DividerView()
    lazy var dmUserCollectionView = {
        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.user))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        
        return cv
    }()
    let dividerLine2 = DividerView()
    lazy var dmChatCollectionView = {
        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout(.chat))
        cv.register(DMCollectionViewCell.self, forCellWithReuseIdentifier: DMCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    override func configureHierarchy() {
        addSubview(dividerLine)
        addSubview(dmUserCollectionView)
        addSubview(dividerLine2)
        addSubview(dmChatCollectionView)
    }
    
    override func configureLayout() {
        spaceImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        myProfileButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dmUserCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(15)
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
    
    override func configureView() {
        super.configureView()
        
        spaceImageView.backgroundColor = .gray
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
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        return layout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spaceImageView.layer.cornerRadius = 8
        spaceImageView.clipsToBounds = true
        
        myProfileButton.layer.cornerRadius = myProfileButton.bounds.width / 2
        myProfileButton.clipsToBounds = true
    }
}
