//
//  RoundCameraView.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class RoundCameraView: BaseView {
    private let roundImageView = RoundImageView()
    private let cameraButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(roundImageView)
        addSubview(cameraButton)
    }
    
    override func configureLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(77)
            make.height.equalTo(75)
        }
        
        roundImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(70)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
        roundImageView.image = .workspace
        cameraButton.setImage(.camera, for: .normal)
    }
    
    func setBackgroundImage(_ image: UIImage) {
        roundImageView.image = image
    }
    
    func setRoundImageFromServer(image: String?) {
        if let imageURL = image, let url = URL(string: apiUrl + imageURL) {
            roundImageView.kf.setImage(with: url)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.roundImageView.image = .workspace
            }
        }
    }
    
    func setRoundImageFromPicker(image: UIImage?) {
        self.roundImageView.image = image
    }
    
    func cameraButtonTap() -> ControlEvent<Void> {
        return cameraButton.rx.tap
    }
}
