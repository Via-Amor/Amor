//
//  HomeCollectionHeaderView.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import UIKit

final class HomeCollectionHeaderView: UICollectionReusableView {
    let headerLabel = {
        let label = UILabel()
        label.text = "방이름"
        label.font = .Size.title2
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(headerLabel)
    }
    
    private func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(20)
        }
    }
    
    func configureHeaderView(header: String) {
        configureHierarchy()
        configureLayout()
        headerLabel.text = header
    }
}
