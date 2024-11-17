//
//  HomeCollectionHeaderView.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeCollectionHeaderView: UICollectionReusableView {
    var isOpen: Bool = false
    var disposeBag = DisposeBag()
    
    let headerLabel = {
        let label = UILabel()
        label.text = "방이름"
        label.font = .Size.title2
        label.textAlignment = .left
        
        return label
    }()
    
    let openStatusButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Chevron_right"), for: .normal)
        
        return button
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
        addSubview(openStatusButton)
    }
    
    private func configureLayout() {
        headerLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(safeAreaLayoutGuide).inset(15)
            make.height.equalTo(20)
        }
        
        openStatusButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.size.equalTo(20)
            make.leading.equalTo(headerLabel.snp.trailing).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(15)
        }
    }
    
    func configureHeaderView(item: HomeSectionModel) {
        configureHierarchy()
        configureLayout()
        headerLabel.text = item.header
        self.isOpen = item.isOpen
        openStatusButton.setImage(UIImage(named: isOpen ? "Chevron_down" : "Chevron_right"), for: .normal)
    }
    
    func buttonClicked() -> ControlEvent<Void> {
        return openStatusButton.rx.tap
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
