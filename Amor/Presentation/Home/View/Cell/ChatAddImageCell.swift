//
//  ChatAddImageCell.swift
//  Amor
//
//  Created by 김상규 on 11/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChatAddImageCell: BaseCollectionViewCell {
    private let addImageView = UIImageView()
    private let removeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(addImageView)
        contentView.addSubview(removeButton)
    }
    
    override func configureLayout() {
        addImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(7)
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerX.equalTo(addImageView.snp.trailing)
            make.centerY.equalTo(addImageView.snp.top).offset(1)
        }
    }
    
    private func configureCell() {
        addImageView.layer.cornerRadius = 8
        addImageView.clipsToBounds = true
        removeButton.setImage(.xmarkCircle, for: .normal)
    }
    
    func configureUI(image: UIImage) {
        addImageView.image = image
    }
    
    func cancelButtonTap() -> ControlEvent<Void> {
        return removeButton.rx.tap
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
