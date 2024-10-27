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
//    lazy var userCollectionView = {
//        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setUserCollectionViewLayout())
//        
//        return cv
//    }()
    let dividerLine2 =  {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.5)
        
        return view
    }()
//    lazy var  dmCollectionView = {
//        lazy var cv = UICollectionView(frame: .zero, collectionViewLayout: self.setDmCollectionViewLayout())
//        
//        return cv
//    }()
    override func configureHierarchy() {
        addSubview(dividerLine)
//        addSubview(userCollectionView)
        addSubview(dividerLine2)
//        addSubview(dmCollectionView)
    }
    
    override func configureLayout() {
        dividerLine.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        dividerLine2.snp.makeConstraints { make in
            make.top.equalTo(dividerLine.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    private func setUserCollectionViewLayout() -> UICollectionViewLayout {
        
        
        return UICollectionViewLayout()
    }
    
    private func setDmCollectionViewLayout() -> UICollectionViewLayout {
        
        return UICollectionViewLayout()
    }
}
