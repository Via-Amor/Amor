//
//  ProfileCollectionViewCell.swift
//  Amor
//
//  Created by 김상규 on 11/4/24.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    let profileImageView = RoundCameraView()
    let profileElementLabel = {
        let label = UILabel()
        label.font = .title2
        
        return label
    }()
    let profileLabel = {
        let label = UILabel()
        label.font = .body
        label.textColor = .themeInactive
        
        return label
    }()
    let nextViewImageView = UIImageView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func configureCell(element: ProfileElementEnum, profile: String?) {
        configureHierarchy(element: element)
        configureLayout(element: element)
        
        var title: String?
        
        switch element {
        case .profileImage:
            title = nil
            configureMyProfileImageView(profileImage: profile)
            
        case .sesacCoin:
            title = "\(element.elementName) \(profile ?? "")"
            profileLabel.text = "충전하기"
            nextViewImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
            nextViewImageView.tintColor = .themeInactive
            
        case .nickname, .phone:
            title = element.elementName
            profileLabel.text = profile
            nextViewImageView.image = .chevronRight.withRenderingMode(.alwaysTemplate)
            nextViewImageView.tintColor = .themeInactive
            
        case .logOut:
            title = element.elementName
            profileLabel.text = nil
            
        default:
            title = element.elementName
            profileLabel.text = profile
        }
        
        profileElementLabel.text = title
    }
    
    private func configureHierarchy(element: ProfileElementEnum) {
        switch element {
        case .profileImage:
            addSubview(profileImageView)
        default:
            addSubview(profileElementLabel)
            addSubview(profileLabel)
            addSubview(nextViewImageView)
        }
    }
    
    private func configureLayout(element: ProfileElementEnum) {
        switch element {
        case .profileImage:
            profileImageView.snp.makeConstraints { make in
                make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(10)
                make.centerX.equalTo(safeAreaLayoutGuide)
                make.height.equalTo(80)
            }
        case .sesacCoin, .nickname, .phone:
            configureCanChaneElementCell()
        default:
            configureStaticElementCell()
        }
    }
    
    private func configureMyProfileImageView(profileImage: String?) {
        guard let value = profileImage, let image = UIImage(named: value) else {
            profileImageView.setBackgroundImage(.userSkyblue)
            return
        }
        profileImageView.setBackgroundImage(image)
    }
    
    private func configureCanChaneElementCell() {
        profileElementLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        nextViewImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalTo(profileElementLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(5)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalTo(profileElementLabel)
            make.trailing.equalTo(nextViewImageView.snp.leading)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
    
    private func configureStaticElementCell() {
        profileElementLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.verticalEdges.leading.equalTo(safeAreaLayoutGuide).inset(15)
        }
        
        profileLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalTo(profileElementLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
}
