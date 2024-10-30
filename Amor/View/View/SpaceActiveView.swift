//
//  SpaceActiveView.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit

final class SpaceActiveView: BaseView {
    private let roundCameraView = RoundCameraView()
    
    override func configureHierarchy() {
        addSubview(roundCameraView)
    }
    
    override func configureLayout() {
        roundCameraView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        roundCameraView.setSymbolImage(.workspace)
    }
    
}
