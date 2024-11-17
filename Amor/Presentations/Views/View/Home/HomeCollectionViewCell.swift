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
        label.font = .Size.body
        label.textAlignment = .center
        
        return label
    }()
    let messageCountLabel = {
        let label = UILabel()
        label.text = "88"
        label.textColor = .themeWhite
        label.backgroundColor = .themeGreen
        label.font = .Size.bodyBold
        label.textAlignment = .center
        
        return label
    }()
    let divider = DividerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
    }
    
    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(messageCountLabel)
        addSubview(divider)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(15)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.size.equalTo(20)
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
    
    func configureCell(image: String, name: String, messageCount: Int?) {
        imageView.image = UIImage(named: image)
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
