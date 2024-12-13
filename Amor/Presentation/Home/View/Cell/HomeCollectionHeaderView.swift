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
    // 채널 메뉴
    var isOpen: Bool = false {
        didSet {
            let image: UIImage = isOpen ? .chevronDown : .chevronRight
            openStatusButton.setImage(image, for: .normal)
            layoutIfNeeded()
        }
    }
    
    // 채널 설정 - 멤버 메뉴
    var isOpenUp: Bool = false {
        didSet {
            let image: UIImage = isOpenUp ? .chevronDown : .chevronUp
            openStatusButton.setImage(image, for: .normal)
            layoutIfNeeded()
        }
    }
    
    var disposeBag = DisposeBag()
    
    let headerLabel = {
        let label = UILabel()
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
        configureHierarchy()
        configureLayout()
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
            make.width.equalTo(26)
            make.height.equalTo(24)
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
        headerLabel.text = item.header
        self.isOpen = item.isOpen
        self.divider.isHidden = item.isOpen
    }
    
    func configureHeaderText(text: String) {
        headerLabel.text = text
        divider.isHidden = true
        isOpenUp = true
    }
    
    func buttonClicked() -> ControlEvent<Void> {
        return openStatusButton.rx.tap
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
