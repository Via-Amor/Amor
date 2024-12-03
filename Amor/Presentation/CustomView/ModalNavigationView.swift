//
//  ModalNavigationView.swift
//  Amor
//
//  Created by 홍정민 on 12/3/24.
//

import UIKit
import SnapKit

final class ModalNavigationView: BaseView {
    private let topLineView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    
    override func configureHierarchy() {
        addSubview(topLineView)
        addSubview(closeButton)
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        topLineView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(4)
            make.width.equalTo(36)
            make.centerY.equalToSuperview()
        }
        
        
    }
    
    override func configureView() {
        
    }
    
}
