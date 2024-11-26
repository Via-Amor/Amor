//
//  BaseCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell{
    var disposeBag = DisposeBag()

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
