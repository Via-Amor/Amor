//
//  DMMemberEmptyView.swift
//  Amor
//
//  Created by 홍정민 on 12/12/24.
//

import UIKit
import SnapKit

final class DMMemberEmptyView: BaseView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let inviteButton = CommonButton(
        title: DMMemberEmpty.invite,
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
            make.center.equalTo(safeAreaLayoutGuide)
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
        titleLabel.text = DMMemberEmpty.title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = .title1
        
        subtitleLabel.text = DMMemberEmpty.subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .body
    }
}

extension DMMemberEmptyView {
    enum DMMemberEmpty {
        static let title = "워크스페이스에\n멤버가 없어요"
        static let subtitle = "새로운 팀원을 초대해보세요"
        static let invite = "팀원 초대하기"
    }
}
