//
//  ProfileCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    
    let profileElementLabel = {
        let label = UILabel()
        
        return label
    }()
    let profileLabel = {
        let label = UILabel()
        
        return label
    }()
    let nextViewImageView = UIImageView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureHierarchy() {
        addSubview(profileElementLabel)
        addSubview(profileLabel)
        addSubview(nextViewImageView)
    }
    
    func configureLayout() {
        profileElementLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        nextViewImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(profileElementLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalTo(profileElementLabel)
            make.trailing.equalTo(nextViewImageView.snp.leading).offset(10)
        }
    }
    
    func configureCell(element: String, profile: String) {
        profileElementLabel.text = element
        profileLabel.text = profile
    }
}
