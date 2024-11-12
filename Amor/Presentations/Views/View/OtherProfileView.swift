//
//  OtherProfileView.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import SnapKit

final class OtherProfileView: BaseView {
    let otherProfileImageView = RoundImageView()
    
    override func configureHierarchy() {
        addSubview(otherProfileImageView)
    }
    
    override func configureLayout() {
        otherProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(150)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        guard let image = UIImage(named: "User_bot") else { return }
        otherProfileImageView.image = image
    }
}
