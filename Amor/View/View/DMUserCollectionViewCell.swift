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
        imageView.backgroundColor = .cyan
        
        return imageView
    }()
    let userNameLabel = {
        let label = UILabel()
        label.text = "유저 이름"
        label.backgroundColor = .red
        
        return label
    }()
    let latestMessageDateLabel = {
        let label = UILabel()
        label.text = "88시 88분"
        label.backgroundColor = .blue
        
        return label
    }()
    let latestMessageLabel = {
        let label = UILabel()
        label.text = "안녕 친구들"
        label.backgroundColor = .brown
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    func configureHierarchy(_ type: DMCollectionViewType) {
        switch type {
        case .user:
            addSubview(userImageView)
            addSubview(userNameLabel)
        case .chat:
            addSubview(userImageView)
            addSubview(userNameLabel)
            addSubview(latestMessageDateLabel)
            addSubview(latestMessageLabel)
        }
    }
    
    func configureLayout(_ type: DMCollectionViewType) {
        switch type {
        case .user:
            userImageView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
                make.height.equalTo(userImageView.snp.width)
            }
            
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(userImageView.snp.bottom).offset(5)
                make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(5)
                make.height.equalTo(20)
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
        case .chat:
            userImageView.snp.makeConstraints { make in
                make.top.leading.equalTo(safeAreaLayoutGuide).inset(10)
                make.size.equalTo(60)
                make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            }
            
            userNameLabel.snp.makeConstraints { make in
                make.top.equalTo(userImageView.snp.top)
                make.leading.equalTo(userImageView.snp.trailing).offset(10)
                make.height.equalTo(20)
            }
            
            latestMessageDateLabel.snp.makeConstraints { make in
                make.top.equalTo(userImageView)
                make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
                make.height.equalTo(20)
            }
            
            latestMessageLabel.snp.makeConstraints { make in
                make.top.equalTo(userNameLabel.snp.bottom).offset(5)
                make.leading.equalTo(userImageView.snp.trailing).offset(10)
                make.bottom.equalTo(userImageView)
            }
        }
    }
    
}

enum DMCollectionViewType {
    case user
    case chat
}
