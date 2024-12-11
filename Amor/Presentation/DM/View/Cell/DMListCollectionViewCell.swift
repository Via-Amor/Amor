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
        label.font = .body
        return label
    }()
    let latestMessageDateLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .themeGray
        
        return label
    }()
    let latestMessageLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .themeBlack
        
        return label
    }()
    let unreadCountLabel = {
        let label = UILabel()
        label.font = .body
        label.textAlignment = .center
        label.backgroundColor = .themeGreen
        label.textColor = .themeWhite
        
        return label
    }()
    
    override func configureHierarchy() {
        addSubview(userImageView)
        addSubview(userNameLabel)
        addSubview(latestMessageDateLabel)
        addSubview(latestMessageLabel)
        addSubview(unreadCountLabel)
    }
    
    override func configureLayout() {
        userImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(15)
            make.size.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.top)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.height.equalTo(20)
        }
        
        latestMessageDateLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(20)
        }
        
        latestMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.bottom.equalTo(userImageView)
            make.trailing.lessThanOrEqualTo(unreadCountLabel.snp.leading).offset(-10)
        }
        
        unreadCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(latestMessageLabel)
            make.height.equalTo(18)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.width.greaterThanOrEqualTo(19)
        }
    }
    
    func configureSpaceMemberCell(user: SpaceMember) {
        userNameLabel.text = user.nickname
        if let image = user.profileImage, let url = URL(string: apiUrl + image) {
            userImageView.kf.setImage(with: url)
        } else {
            userImageView.image = .userGreen
        }
    }
    
    func configureDMRoomInfoCell(item: (DMRoomInfo, Int)) {
        let (dmRoomInfo, count) = item
        userNameLabel.text = dmRoomInfo.roomName
        
        if let image = dmRoomInfo.profileImage, let url = URL(string: apiUrl + image) {
            userImageView.kf.setImage(with: url)
        } else {
            userImageView.image = .userGreen
        }
        
        if let content = dmRoomInfo.content {
            if !dmRoomInfo.files.isEmpty {
                latestMessageLabel.text = "(사진) " + content
            } else {
                latestMessageLabel.text = content
            }
        } else {
            if !dmRoomInfo.files.isEmpty {
                latestMessageLabel.text = "(사진)"
            }
        }
        
        if count == 0 {
            unreadCountLabel.isHidden = true
        } else {
            unreadCountLabel.text = "\(count)"
            unreadCountLabel.isHidden = false
        }
        
        latestMessageDateLabel.text = dmRoomInfo.createdAt.toChatTime()
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
