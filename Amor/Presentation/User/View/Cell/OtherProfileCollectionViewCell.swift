//
//  OtherProfileCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 12/15/24.
//

import UIKit
import SnapKit

final class OtherProfileCollectionViewCell: BaseCollectionViewCell {
    let profileLabel = {
        let label = UILabel()
        label.font = .title2
        
        return label
    }()
    let profileValueLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .themeInactive
        
        return label
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func configureHierarchy() {
        addSubview(profileLabel)
        addSubview(profileValueLabel)
    }
    
    override func configureLayout() {
        profileLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        profileValueLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalTo(profileLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }
    
    override func configureView() {
        backgroundColor = .themeWhite
    }
    
    func configureCell(profile: String, value: String) {
        profileLabel.text = profile
        profileValueLabel.text = value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
