//
//  BaseCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell{

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
}
