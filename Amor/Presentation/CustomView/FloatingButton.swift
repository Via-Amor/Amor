//
//  FloatingButton.swift
//  Amor
//
//  Created by 김상규 on 11/17/24.
//

import UIKit
import SnapKit

final class FloatingButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(named: "NewMessage"), for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
