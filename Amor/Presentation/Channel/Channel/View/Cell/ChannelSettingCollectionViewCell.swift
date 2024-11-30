//
//  ChannelSettingCollectionViewCell.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import UIKit
import SnapKit

final class ChannelSettingCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = RoundImageView()
    private let nicknameLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(44)
            make.centerX.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(contentView).inset(6)
        }
    }
    
    override func configureView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        nicknameLabel.font = .body
        nicknameLabel.numberOfLines = 2
        nicknameLabel.textAlignment = .center
    }
    
    func configureData(data: ChannelMember) {
        if let profile = data.profileImage, let imageURL = URL(string: apiUrl + profile) {
            profileImageView.kf.setImage(with: imageURL)
        } else {
            profileImageView.image = .userGreen
        }
        
        nicknameLabel.text = data.nickname
    }
}
