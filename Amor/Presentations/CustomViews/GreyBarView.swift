//
//  GreyBarView.swift
//  Amor
//
//  Created by 양승혜 on 10/28/24.
//

import UIKit
import SnapKit

final class GreyBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .themeGray
        
        self.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.width.equalTo(36)
        }
        layer.cornerRadius = 2
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
