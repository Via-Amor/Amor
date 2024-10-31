//
//  RoundImageView.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit

final class RoundImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 8
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
