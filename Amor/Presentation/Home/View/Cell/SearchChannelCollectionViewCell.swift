//
//  SearchChannelCollectionViewCell.swift
//  Amor
//
//  Created by 홍정민 on 12/18/24.
//

import UIKit
import SnapKit

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
            make.horizontalEdges.equalTo(channelNameLabel)
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
        isAttendLabel.font = .mini
        isAttendLabel.layer.cornerRadius = 8
        isAttendLabel.clipsToBounds = true
        isAttendLabel.textAlignment = .center
        
        channelNameLabel.text = "정민이네 토크방"
        channelDescriptionLabel.text = "여기는 수다떨고 토크하는 방"
        isAttendLabel.text = "참여중"
    }

}
