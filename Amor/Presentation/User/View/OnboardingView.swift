//
//  OnboardingView.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    private let descriptionLabel = UILabel()
    private let onboardingImageView = UIImageView()
    let startButton = CommonButton(
        title: "시작하기",
        foregroundColor: .themeWhite,
        backgroundColor: .themeGreen
    )
    
    override func configureHierarchy() {
        addSubview(descriptionLabel)
        addSubview(onboardingImageView)
        addSubview(startButton)
    }
    
    override func configureLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(39)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        onboardingImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(89)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(13)
            make.height.equalTo(snp.width)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary
        
        descriptionLabel.font = .title1
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = "새싹톡을 사용하면 어디서나\n팀을 모을 수 있습니다"
        
        onboardingImageView.image = .onboarding
        onboardingImageView.contentMode = .scaleAspectFill
        onboardingImageView.clipsToBounds = true
    }
    
}
