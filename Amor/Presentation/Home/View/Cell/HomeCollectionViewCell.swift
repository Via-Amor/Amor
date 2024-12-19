//
//  HomeCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeCollectionViewCell: BaseCollectionViewCell {
    let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    let nameLabel = {
        let label = UILabel()
        label.font = .body
        label.textAlignment = .center
        
        return label
    }()
    let messageCountLabel = {
        let label = PaddingLabel()
        label.textColor = .themeWhite
        label.backgroundColor = .themeGreen
        label.font = .caption
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
            make.trailing.equalTo(safeAreaLayoutGuide).inset(17)
            make.width.greaterThanOrEqualTo(19)
            make.height.equalTo(18)
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
            imageView.image = .userSkyblue
        }
        
        nameLabel.text = name
        
        if let count = messageCount, count > 0 {
            messageCountLabel.isHidden = false
            messageCountLabel.text = String(count)
        } else {
            messageCountLabel.isHidden = true
        }
    }
    
    func addDivider(isVisable: Bool) {
        divider.isHidden = !isVisable
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 4
        messageCountLabel.layer.cornerRadius = 8
        messageCountLabel.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = UIImage()
        disposeBag = DisposeBag()
    }
}
