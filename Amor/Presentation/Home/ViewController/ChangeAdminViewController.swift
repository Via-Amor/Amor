//
//  ChangeAdminViewController.swift
//  Amor
//
//  Created by 홍정민 on 12/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChangeAdminViewController: BaseVC<ChangeAdminView> {
    var coordinator: ChangeAdminCoordinator?
    
    override func configureNavigationBar() {
        navigationItem.title = Navigation.changeChannelAdmin
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Design.Icon.xmark,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .themeBlack
    }
    
    override func bind() {
        Observable.just(memberList)
            .bind(to: baseView.memberCollectionView.rx.items(cellIdentifier: SpaceCollectionViewCell.identifier, cellType: SpaceCollectionViewCell.self)) {
                (row, element, cell) in
                cell.configureCell(item: element)
            }
            .disposed(by: disposeBag)
    }
    
}

let memberList = [
    ChannelMemberDTO(
        user_id: "1234",
        email: "jm@naver.com",
        nickname: "황금두더지",
        profileImage: "/static/profiles/1732975356096.jpeg"
    ),
    ChannelMemberDTO(
        user_id: "1234",
        email: "jm@naver.com",
        nickname: "황금두더지",
        profileImage: "/static/profiles/1732975356096.jpeg"
    ),
    ChannelMemberDTO(
        user_id: "1234",
        email: "jm@naver.com",
        nickname: "황금두더지",
        profileImage: "/static/profiles/1732975356096.jpeg"
    ),
    ChannelMemberDTO(
        user_id: "1234",
        email: "jm@naver.com",
        nickname: "황금두더지",
        profileImage: "/static/profiles/1732975356096.jpeg"
    )
]

