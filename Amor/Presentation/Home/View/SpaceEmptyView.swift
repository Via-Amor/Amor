//
//  SpaceEmptyView.swift
//  Amor
//
//  Created by 김상규 on 12/19/24.
//

import UIKit
import SnapKit

final class SpaceEmptyView: BaseView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let inviteButton = CommonButton(
        title: SpaceEmpty.invite,
        foregroundColor: .themeWhite,
        backgroundColor: .themeGreen
    )
    
    override func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(inviteButton)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(229)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(62)
        }
        
        subtitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        inviteButton.snp.remakeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(19)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(62)
        }
    }
    
    override func configureView() {
        titleLabel.text = SpaceEmpty.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = .title1
        
        subtitleLabel.text = SpaceEmpty.subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .body
    }
}

extension SpaceEmptyView {
    enum SpaceEmpty {
        static let title = "라운지를 찾을 수 없어요"
        static let subtitle = "관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 라운지를 생성해주세요."
        static let invite = "라운지 생성"
    }
}
