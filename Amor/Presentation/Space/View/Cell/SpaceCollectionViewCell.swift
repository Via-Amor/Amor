//
//  SpaceCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/29/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class SpaceCollectionViewCell: BaseCollectionViewCell {
    let spaceImageView = UIImageView()
    let spaceTitleLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 1
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
        let image = Design.Icon.threeDots.withTintColor(.themeBlack)
        button.setImage(image, for: .normal)
        
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
    
    func configureCell(spaceSimpleInfo: SpaceSimpleInfo) {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        if let image = spaceSimpleInfo.coverImage, let url = URL(string: apiUrl + image) {
            spaceImageView.kf.setImage(with: url)
        } else {
            spaceImageView.backgroundColor = .systemGreen
        }
        spaceTitleLabel.text = spaceSimpleInfo.name
        createdDateLabel.text = spaceSimpleInfo.createdAt.toSpaceCreatedDate()
        configureisCurrentSpaceCell(isCurrentSpace: spaceSimpleInfo.isCurrentSpace)
    }
    
    func configureisCurrentSpaceCell(isCurrentSpace: Bool) {
        contentView.backgroundColor = isCurrentSpace ? .themeGray : .white
        moreButton.isHidden = !isCurrentSpace
    }
    
    func tapMoreButton() -> ControlEvent<Void> {
        return moreButton.rx.tap
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
