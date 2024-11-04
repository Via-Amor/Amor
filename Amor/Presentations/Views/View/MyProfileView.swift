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
    lazy var profileCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.setProfileCollectionViewLayout())
        cv.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        
        return cv
    }()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(profileCollectionView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(20)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    func configureMyProfileImageView(profileImage: UIImage?) {
        guard let image = profileImage else { return }
        profileImageView.setBackgroundImage(image)
    }
}
