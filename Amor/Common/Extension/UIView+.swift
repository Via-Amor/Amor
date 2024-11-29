//
//  UIView+.swift
//  Amor
//
//  Created by 김상규 on 11/1/24.
//

import UIKit

// MARK: UIView+
extension UIView: ViewIdentifier {
    static var identifier: String {
        String(describing: self)
    }
}

// MARK: ChatInputView+
extension UIView {
    func setChatAddImageCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .absolute(60)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: HomeView+
extension UIView {
    func setHomeCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // 리스트 레이아웃 구성
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            // 헤더 추가
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            switch sectionIndex {
            case 0:
                section.boundarySupplementaryItems = [header]
            case 1:
                section.boundarySupplementaryItems = [header]
            default:
                break
            }
            
            return section
        }
    }
}

// MARK: DMView+
extension UIView {
    func setDmCollectionViewLayout(_ type: DMCollectionViewType) -> UICollectionViewLayout {
        
        let layout: UICollectionViewLayout
        
        switch type {
        case .spaceMember:
            layout = setDMUserCollectionViewLayout()
        case .dmRoom:
            layout = setListCollectionViewLayout(spacing: 1)
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

// MARK: SideSpaceMenuView+
extension UIView {
    func setSideSpaceMenuCollectionViewLayout() -> UICollectionViewLayout {
        return setListCollectionViewLayout(spacing: 10)
    }
}

// MARK:  ListCollectionViewLayout
extension UIView {
    private func setListCollectionViewLayout(spacing: CGFloat) -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        layout.configuration.interSectionSpacing = spacing
        
        return layout
    }
}
