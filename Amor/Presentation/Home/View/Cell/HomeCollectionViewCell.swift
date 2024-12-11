//
//  HomeCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCell: BaseCollectionViewCell {
    let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let nameLabel = {
        let label = UILabel()
        label.text = "방이름"
        label.font = .body
        label.textAlignment = .center
        
        return label
    }()
    let messageCountLabel = {
        let label = UILabel()
        label.text = "88"
        label.textColor = .themeWhite
        label.backgroundColor = .themeGreen
        label.font = .bodyBold
        label.textAlignment = .center
        
        return label
    }()
    let divider = DividerView()
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(messageCountLabel)
        addSubview(divider)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalTo(imageView)
            make.height.equalTo(25)
        }
        
        messageCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.leading.equalTo(nameLabel).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(15)
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    func configureCell<T>(image: T, name: String, messageCount: Int?) {
        if let image = image as? String, let url = URL(string: apiUrl + image) {
            imageView.kf.setImage(with: url)
        } else if let image = image as? UIImage {
            imageView.image = image
        } else {
            imageView.image = .userBot
        }
        nameLabel.text = name
        if let count = messageCount, count > 0 {
            messageCountLabel.text = String(count)
        } else {
            messageCountLabel.isHidden = true
        }
    }
    
    func addDivider(isVidsble: Bool) {
        divider.isHidden = !isVidsble
    }
    
    override func layoutSubviews() {
        imageView.layer.cornerRadius = 4
    }
}
