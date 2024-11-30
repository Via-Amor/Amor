//
//  ChannelSettingView.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import UIKit
import SnapKit

final class ChannelSettingView: BaseView {
    enum SettingButtonTitle: String, CaseIterable {
        case edit = "채널 편집"
        case exit = "채널에서 나가기"
        case manager = "채널 관리자 변경"
        case delete = "채널 삭제"
    }
    
    let scrollView = UIScrollView()
    let backgroundView = UIView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let memberCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .channelSettingLayout
    )
    let buttonStackView = UIStackView()
    let editButton = BorderRadiusButton()
    let exitButton = BorderRadiusButton()
    let adminButton = BorderRadiusButton()
    let deleteButton = BorderRadiusButton(borderButtonType: .destructive)
    private lazy var buttonList = [editButton, exitButton, adminButton, deleteButton]
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(memberCollectionView)
        backgroundView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(exitButton)
        buttonStackView.addArrangedSubview(adminButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        memberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(106)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(memberCollectionView.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().offset(-30)
        }
        
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary

        memberCollectionView.register(
            ChannelSettingCollectionViewCell.self,
            forCellWithReuseIdentifier: ChannelSettingCollectionViewCell.identifier
        )
        
        memberCollectionView.register(
            HomeCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeCollectionHeaderView.identifier
        )
        
        memberCollectionView.isScrollEnabled = false
        memberCollectionView.backgroundColor = .backgroundPrimary
        
        titleLabel.font = .title2
        descriptionLabel.font = .body
        descriptionLabel.numberOfLines = 0
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 8
        
        for (idx, value) in SettingButtonTitle.allCases.enumerated() {
            buttonList[idx].configureTitle(title: value.rawValue)
        }
    }
    
    /* 실질적으로 사용되는 부분 */
    func configureData(data: ChannelDetail) {
        titleLabel.text = data.name
        descriptionLabel.text = data.description
    }
    
    func hideAdminButton() {
        [editButton, adminButton, deleteButton].forEach { button in
            button.isHidden = true
        }
    }
    
}


