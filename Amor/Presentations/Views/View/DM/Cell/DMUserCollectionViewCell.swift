//
//  DMUserCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 10/27/24.
//

import UIKit
import SnapKit

final class DMCollectionViewCell: BaseCollectionViewCell {
//    var type: DMCollectionViewType
    
    let userImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    let userNameLabel = {
        let label = UILabel()
        label.text = "유저 이름"
        label.textAlignment = .center
        
        return label
    }()
    let latestMessageDateLabel = {
        let label = UILabel()
        label.text = "88시 88분"
        
        return label
    }()
    let latestMessageLabel = {
        let label = UILabel()
        label.text = "안녕 친구들"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureHierarchy(_ type: DMCollectionViewType) {
        switch type {
        case .spaceMember:
            addSubview(userImageView)
            addSubview(userNameLabel)
        case .dmRoom:
            addSubview(userImageView)
            addSubview(userNameLabel)
            addSubview(latestMessageDateLabel)
            addSubview(latestMessageLabel)
        }
    }
    
    func configureLayout(_ type: DMCollectionViewType) {
        switch type {
        case .spaceMember:
            userImageView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
                make.height.equalTo(userImageView.snp.width)
            }
            
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(userImageView.snp.bottom).offset(5)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
                make.height.equalTo(20)
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
            
        case .dmRoom:
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
            }
        }
    }
    
    func configureSpaceMemberCell(user: DMSpaceMember) {
        userNameLabel.text = user.nickname
        userImageView.image = UIImage(named: "User_bot")
    }
    
    func configureDMRoomCell(dmRoom: DMRoom) {
        userNameLabel.text = dmRoom.user.nickname
        userImageView.image = UIImage(named: "User_bot")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.layer.cornerRadius = 8
        userImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
    }
}

enum DMCollectionViewType {
    case spaceMember
    case dmRoom
}
