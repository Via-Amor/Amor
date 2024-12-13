//
//  DMCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DMListCollectionViewCell: BaseCollectionViewCell {
    let userImageView = RoundImageView()
    let userNameLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .caption
        return label
    }()
    let latestMessageDateLabel = {
        let label = UILabel()
        label.font = .mini
        label.textColor = .textSecondary
        
        return label
    }()
    let latestMessageLabel = {
        let label = UILabel()
        label.font = .mini
        label.textColor = .textSecondary
        label.numberOfLines = 2
        
        return label
    }()
    let unreadCountLabel = {
        let label = PaddingLabel()
        label.font = .caption
        label.textAlignment = .center
        label.backgroundColor = .themeGreen
        label.textColor = .themeWhite
        
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(latestMessageDateLabel)
        contentView.addSubview(latestMessageLabel)
        contentView.addSubview(unreadCountLabel)
    }
    
    override func configureLayout() {
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(6)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.size.equalTo(34)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        latestMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(userNameLabel)
            make.trailing.lessThanOrEqualTo(unreadCountLabel.snp.leading).offset(-5)
            make.bottom.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.top.equalTo(latestMessageLabel)
            make.width.greaterThanOrEqualTo(19)
            make.trailing.equalTo(latestMessageDateLabel)
        }
    }
    
    func configureDMRoomInfoCell(item: DMListContent) {
        userNameLabel.text = item.nickname
        
        if let image = item.profileImage, let url = URL(string: apiUrl + image) {
            userImageView.kf.setImage(with: url)
        } else {
            userImageView.image = .userGreen
        }
        
        if let content = item.content {
            if !item.files.isEmpty {
                latestMessageLabel.text = "(사진) " + content
            } else {
                latestMessageLabel.text = content
            }
        } else {
            if !item.files.isEmpty {
                latestMessageLabel.text = "(사진)"
            }
        }
        
        if item.unreadCount == 0 {
            unreadCountLabel.isHidden = true
        } else {
            unreadCountLabel.text = "\(item.unreadCount)"
            unreadCountLabel.isHidden = false
        }
        
        latestMessageDateLabel.text = item.createdAt.toChatTime()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = 8
        userImageView.clipsToBounds = true
        
        unreadCountLabel.layer.cornerRadius = 8
        unreadCountLabel.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = UIImage()
    }
}
