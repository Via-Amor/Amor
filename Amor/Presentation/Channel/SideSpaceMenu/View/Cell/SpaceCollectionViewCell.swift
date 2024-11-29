//
//  SpaceCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import SnapKit
import RxSwift

final class SpaceCollectionViewCell: BaseCollectionViewCell {
    let spaceImageView = UIImageView()
    let spaceTitleLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        return label
    }()

    let createdDateLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .textSecondary
        return label
    }()
    let moreButton = {
        let button = UIButton()
        button.setImage(Design.Icon.threeDots, for: .normal)
        button.tintColor = .themeBlack
        
        return button
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(spaceImageView)
        contentView.addSubview(spaceTitleLabel)
        contentView.addSubview(createdDateLabel)
        contentView.addSubview(moreButton)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        spaceImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.centerY.equalTo(spaceImageView)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        spaceTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(spaceImageView.snp.trailing).offset(5)
            make.trailing.equalTo(moreButton.snp.leading).inset(-5)
            make.bottom.equalTo(spaceImageView.snp.centerY)
            make.height.equalTo(18)
        }
        
        createdDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(spaceTitleLabel)
            make.trailing.equalTo(moreButton.snp.leading).inset(-5)
            make.top.equalTo(spaceImageView.snp.centerY)
            make.height.equalTo(18)
            make.width.equalTo(spaceTitleLabel)
        }
    }
    
    func configureCell() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        spaceImageView.backgroundColor = .systemGreen
        spaceTitleLabel.backgroundColor = .systemBlue
        createdDateLabel.backgroundColor = .systemCyan
        moreButton.backgroundColor = .systemGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spaceImageView.layer.cornerRadius = 8
        spaceImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        backgroundColor = .white
    }
}
