//
//  ChatAddImageView.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import UIKit
import SnapKit

final class ChatAddImageView: UIView {
    private let addImageView = UIImageView()
    private let removeButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        addSubview(addImageView)
        addSubview(removeButton)
    }
    
    private func configureLayout() {
        addImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.centerX.equalTo(safeAreaLayoutGuide.snp.leading)
            make.centerY.equalTo(safeAreaLayoutGuide.snp.top)
        }
    }
    
    private func configureView() {
        addImageView.layer.cornerRadius = 8
        removeButton.setImage(UIImage(named: "xmark.circle"), for: .normal)
    }
    
    func configureUI(image: UIImage) {
        addImageView.image = image
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
