//
//  SearchChannelCollectionViewCell.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchChannelCollectionViewCell: BaseCollectionViewCell {
    private let channelImageView = RoundImageView()
    private let channelNameLabel = UILabel()
    private let channelDescriptionLabel = UILabel()
    private let isAttendLabel = PaddingLabel()
    
    override func configureHierarchy() {
        contentView.addSubview(channelImageView)
        contentView.addSubview(channelNameLabel)
        contentView.addSubview(channelDescriptionLabel)
        contentView.addSubview(isAttendLabel)
    }
    
    override func configureLayout() {
        channelImageView.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(15)
        }
        
        channelNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelImageView.snp.trailing).offset(10)
            make.trailing.equalTo(isAttendLabel.snp.leading).offset(-15)
            make.top.equalTo(channelImageView)
        }
        
        channelDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(channelNameLabel)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(channelNameLabel.snp.bottom).offset(2)
        }
        
        isAttendLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
    }
    
    override func configureView() {
        channelImageView.image = .userSkyblue
        channelNameLabel.font = .body
        channelDescriptionLabel.font = .caption
        channelDescriptionLabel.textColor = .themeGray
        isAttendLabel.backgroundColor = .themeGreen
        isAttendLabel.textColor = .themeWhite
        isAttendLabel.font = .miniBold
        isAttendLabel.layer.cornerRadius = 8
        isAttendLabel.clipsToBounds = true
        isAttendLabel.textAlignment = .center
        isAttendLabel.text = "참여중"
    }
    
    func configureData(data: ChannelList) {
        if let image = data.coverImage,
           let imageURL = URL(string: apiUrl + image) {
            channelImageView.kf.setImage(with: imageURL)
        } else {
            channelImageView.image = .workspace
        }
        
        channelNameLabel.text = data.name
        channelDescriptionLabel.text = data.description
        isAttendLabel.isHidden = !data.isAttend
    }

}
