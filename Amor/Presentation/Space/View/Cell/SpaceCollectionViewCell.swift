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
    let imageView = UIImageView()
    let titleLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 1
        return label
    }()

    let subTitleLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .textSecondary
        return label
    }()
    let moreButton = {
        let button = UIButton()
        let image: UIImage = .threeDots.withTintColor(.themeBlack)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(moreButton)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(5)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(0)
            make.centerY.equalTo(imageView)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(5)
            make.trailing.equalTo(moreButton.snp.leading).inset(-5)
            make.bottom.equalTo(imageView.snp.centerY)
            make.height.equalTo(18)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(moreButton.snp.leading).inset(-5)
            make.top.equalTo(imageView.snp.centerY)
            make.height.equalTo(18)
            make.width.equalTo(titleLabel)
        }
    }
    
    func configureCell<T>(item: T) {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        switch item {
        case let spaceSimpleInfo as SpaceSimpleInfo:
            if let image = spaceSimpleInfo.coverImage, let url = URL(string: apiUrl + image) {
                imageView.kf.setImage(with: url)
            } else {
                imageView.backgroundColor = .systemGreen
            }
            titleLabel.text = spaceSimpleInfo.name
            subTitleLabel.text = spaceSimpleInfo.createdAt.toSpaceCreatedDate()
            setMoreButtonLayout(isHidden: false)
            configureisCurrentSpaceCell(isCurrentSpace: spaceSimpleInfo.isCurrentSpace)
        case let spaceMember as SpaceMember:
            if let image = spaceMember.profileImage, let url = URL(string: apiUrl + image) {
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = .userGreen
            }
            
            setMoreButtonLayout(isHidden: true)
            titleLabel.text = spaceMember.nickname
            subTitleLabel.text = spaceMember.email
        case let channelMember as ChannelMember:
            if let image = channelMember.profileImage, let url = URL(string: apiUrl + image) {
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = .userGreen
            }
            setMoreButtonLayout(isHidden: true)
            titleLabel.text = channelMember.nickname
            subTitleLabel.text = channelMember.email
        default:
            setMoreButtonLayout(isHidden: true)
        }
    }
    
    func configureisCurrentSpaceCell(isCurrentSpace: Bool) {
        contentView.backgroundColor = isCurrentSpace ? .themeGray : .white
        moreButton.isHidden = !isCurrentSpace
    }
    
    func tapMoreButton() -> ControlEvent<Void> {
        return moreButton.rx.tap
    }
    
    private func setMoreButtonLayout(isHidden: Bool) {
        moreButton.isHidden = isHidden
        
        if !isHidden {
            moreButton.snp.updateConstraints { make in
                make.size.equalTo(30)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        backgroundColor = .white
    }
}
