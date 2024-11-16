//
//  UIView+.swift
//  Amor
//
//  Created by 김상규 on 11/1/24.
//

import UIKit

// MARK: DMView+
extension UIView {
    func setDmCollectionViewLayout(_ type: DMCollectionViewType) -> UICollectionViewLayout {
        
        let layout: UICollectionViewLayout
        
        switch type {
        case .spaceMember:
            layout = setDMUserCollectionViewLayout()
        case .dmRoom:
            layout = setDMChatCollectionViewLayout()
        }
        
        return layout
    }
    
    private func setDMUserCollectionViewLayout() -> UICollectionViewLayout {
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(
//            layoutSize: headerSize,
//            elementKind: UICollectionView.elementKindSectionHeader,
//            alignment: .top
//        )
//        header.pinToVisibleBounds = false
        
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
//        section.boundarySupplementaryItems = [header]
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
}

// MARK: ProfileView+
extension UIView {
    func setProfileCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            var configuration: UICollectionLayoutListConfiguration
            
            switch sectionIndex {
            case 0:
                configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                configuration.backgroundColor = .clear
            default:
                configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            }
            
            configuration.showsSeparators = false
            
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
        }
    }
}
