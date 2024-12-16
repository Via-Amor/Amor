//
//  SpaceActiveView.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SpaceActiveView: BaseView {
    private let roundCameraView = RoundCameraView()
    private let nameTextField = LabeledTextField(
        title: "워크스페이스 이름",
        placeholderText: "워크스페이스 이름을 입력하세요 (필수)"
    )
    private let descriptionTextField = LabeledTextField(
        title: "워크스페이스 설명",
        placeholderText: "워크스페이스를 설명하세요 (옵션)"
    )
    private let completeButton = CommonButton(
        title: "완료",
        foregroundColor: .themeWhite,
        backgroundColor: .themeInactive
    )
    
    override func configureHierarchy() {
        addSubview(roundCameraView)
        addSubview(nameTextField)
        addSubview(descriptionTextField)
        addSubview(completeButton)
    }
    
    override func configureLayout() {
        roundCameraView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(roundCameraView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-12)
        }
    }
    
    override func configureView() {
        backgroundColor = .backgroundPrimary
    }
}

extension SpaceActiveView {
    func nameTextFieldText() -> ControlProperty<String> {
        return nameTextField.textField.rx.text.orEmpty
    }
    
    func descriptionTextFieldText() -> ControlProperty<String?> {
        return descriptionTextField.textField.rx.text
    }
    
    func confirmButtonTap() -> ControlEvent<Void> {
        return completeButton.rx.tap
    }
    
    func cameraButtonTap() -> ControlEvent<Void> {
        return roundCameraView.cameraButtonTap()
    }
}

extension SpaceActiveView {
    func setNameTextField(name: String) {
        nameTextField.textField.text = name
    }
    
    func setdescriptionTextField(description: String?) {
        descriptionTextField.textField.text = description
    }
    
    func setSpaceImageFromServer(image: String?) {
        roundCameraView.setRoundImageFromServer(image: image)
    }
    
    func setSpaceImageFromPicker(image: UIImage?) {
        roundCameraView.setRoundImageFromPicker(image: image)
    }
    
    func completeButtonEnabled(isEnabled: Bool) {
        completeButton.isUserInteractionEnabled = isEnabled
        completeButton.configuration?.baseBackgroundColor = isEnabled ? .themeGreen : .themeInactive
    }
}
