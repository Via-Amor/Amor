//
//  SpaceInitialView.swift
//  Amor
//
//  Created by 홍정민 on 10/29/24.
//

import UIKit
import SnapKit

final class SpaceInitialView: BaseView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let initialImage = UIImageView()
    private let createButton = CommonButton(
        title: "워크스페이스 생성",
        foregroundColor: .white,
        backgroundColor: .themeGreen
    )
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(initialImage)
        addSubview(createButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(35)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        initialImage.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.width.equalToSuperview().inset(12)
            make.height.equalTo(snp.width)
        }
        
        createButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        titleLabel.text = "출시 준비 완료!"
        titleLabel.textAlignment = .center
        titleLabel.font = .title1
        descriptionLabel.text = "옹골찬 고래밥님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!"
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .body
        initialImage.image = UIImage.launching
        initialImage.contentMode = .scaleAspectFill
        initialImage.clipsToBounds = true
    }
    
}

