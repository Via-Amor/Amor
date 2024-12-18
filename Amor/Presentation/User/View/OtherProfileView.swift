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
    lazy var otherProfileCollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .setProfileCollectionViewLayout())
        cv.register(OtherProfileCollectionViewCell.self, forCellWithReuseIdentifier: OtherProfileCollectionViewCell.identifier)
        cv.isScrollEnabled = false
        
        return cv
    }()
    private let dmChatButton = CommonButton(title: "DM 하기", foregroundColor: .themeWhite, backgroundColor: .themeGreen)
    
    override func configureHierarchy() {
        addSubview(otherProfileImageView)
        addSubview(otherProfileCollectionView)
        addSubview(dmChatButton)
    }
    
    override func configureLayout() {
        otherProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(80)
            make.height.equalTo(otherProfileImageView.snp.width)
        }
        
        otherProfileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(otherProfileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(dmChatButton.snp.top).inset(-20)
        }
        
        dmChatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(25)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary
        
        otherProfileImageView.contentMode = .scaleAspectFill
        otherProfileImageView.layer.borderColor = UIColor.themeInactive.cgColor
        otherProfileImageView.layer.borderWidth = 1
    }
    
    func setOtherProfileImage(image: String?) {
        if let image = image, let url = URL(string: apiUrl + image) {
            otherProfileImageView.kf.setImage(with: url)
        } else {
            otherProfileImageView.backgroundColor = .themeGreen
            otherProfileImageView.image = .userSkyblue
        }
    }
}
