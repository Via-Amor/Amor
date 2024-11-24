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
    var isOpen: Bool = false {
        didSet {
            openStatusButton.setImage(UIImage(named: isOpen ? "Chevron_down" : "Chevron_right"), for: .normal)
            
            layoutIfNeeded()
        }
    }
    var disposeBag = DisposeBag()
    
    let headerLabel = {
        let label = UILabel()
        label.text = "방이름"
        label.font = .title2
        label.textAlignment = .left
        
        return label
    }()
    
    let openStatusButton = {
        let button = UIButton()
        
        return button
    }()
    
    let divider = DividerView()
    
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
        addSubview(divider)
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
        
        divider.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
    }
    
    func configureHeaderView(item: HomeSectionModel) {
        configureHierarchy()
        configureLayout()
        headerLabel.text = item.header
        self.isOpen = item.isOpen
        self.divider.isHidden = item.isOpen
    }
    
    func buttonClicked() -> ControlEvent<Void> {
        return openStatusButton.rx.tap
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
