//
//  PaddingLabel.swift
//  Amor
//
//  Created by 홍정민 on 12/11/24.
//

import UIKit

final class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(
        top: 2,
        left: 4,
        bottom: 2,
        right: 4
    )

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
