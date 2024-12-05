//
//  CustomAlert.swift
//  Amor
//
//  Created by 김상규 on 11/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CustomAlert: BaseView {
    enum AlertType {
        case oneButton
        case twoButton
    }
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    lazy var confirmButton = CommonButton(title: AlertText.AlertButtonText.confirm.rawValue, foregroundColor: .themeWhite, backgroundColor: .themeGreen)
    var cancelButton = CommonButton(title: AlertText.AlertButtonText.cancel.rawValue, foregroundColor: .themeWhite, backgroundColor: .themeInactive)
    
    let alertType: AlertType
    
    init(alertType: AlertType) {
        self.alertType = alertType
        
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    override func configureHierarchy() {
        addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(confirmButton)
        
        switch alertType {
        case .oneButton:
            break
        case .twoButton:
            containerView.addSubview(cancelButton)
        }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(30)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(10)
            make.horizontalEdges.equalTo(containerView).inset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(containerView).inset(10)
        }
        
        switch alertType {
        case .oneButton:
            confirmButton.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalTo(containerView).inset(10)
                make.height.equalTo(44)
                make.bottom.equalTo(containerView.snp.bottom).inset(10)
            }
        case .twoButton:
            cancelButton.snp.makeConstraints { make in
                make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                make.leading.equalTo(containerView.snp.leading).offset(10)
                make.height.equalTo(44)
                make.bottom.equalTo(containerView.snp.bottom).inset(10)
            }
            
            confirmButton.snp.makeConstraints { make in
                make.leading.equalTo(cancelButton.snp.trailing).offset(10)
                make.trailing.equalTo(containerView.snp.trailing).inset(10)
                make.size.equalTo(cancelButton)
                make.bottom.equalTo(containerView.snp.bottom).inset(10)
            }
        }
    }
    
    func configureView(title: String, subtitle: String) {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        titleLabel.text = title
        titleLabel.font = .title2
        titleLabel.textAlignment = .center
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = .body
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonTap() -> ControlEvent<Void> {
        return cancelButton.rx.tap
    }
    
    func confirmButtonTap() -> ControlEvent<Void> {
        return confirmButton.rx.tap
    }
}
