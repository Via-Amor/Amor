//
//  DMUserCollectionViewCell.swift
//  Amor
//
//  Created by 홍정민 on 12/11/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DMUserCollectionViewCell: BaseCollectionViewCell {
    let userImageView = RoundImageView()
    let userNameLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .body
        label.numberOfLines = 2
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
    }
    
    override func configureLayout() {
        userImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(5)
        }
    }
    
    func configureData(data: SpaceMember) {
        userNameLabel.text = data.nickname
        
        if let image = data.profileImage {
            userImageView.setImageFromURL(url: image)
        } else {
            userImageView.image = .userSkyblue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = UIImage()
    }
}
