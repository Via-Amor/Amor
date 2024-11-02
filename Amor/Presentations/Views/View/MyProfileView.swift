//
//  MyProfileView.swift
//  Amor
//
//  Created by 김상규 on 10/31/24.
//

import UIKit
import SnapKit

final class MyProfileView: BaseView {
    let profileImageView = RoundCameraView()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        guard let image = UIImage(named: "User_green") else { return }
        profileImageView.setBackgroundImage(image)
    }
}
