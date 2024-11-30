//
//  RoundCameraView.swift
//  Amor
//
//  Created by 홍정민 on 10/30/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RoundCameraView: BaseView {
    private let roundImageView = RoundImageView()
    private let symbolImageView = UIImageView()
    private let cameraButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(roundImageView)
        addSubview(symbolImageView)
        addSubview(cameraButton)
    }
    
    override func configureLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(77)
            make.height.equalTo(75)
        }
        
        roundImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.top.leading.equalToSuperview()
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(60)
            make.top.equalTo(roundImageView).offset(10)
            make.horizontalEdges.equalTo(roundImageView).inset(11)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        cameraButton.setImage(.camera, for: .normal)
    }
    
    // 심볼(아이콘) 이미지 설정
    func setSymbolImage(_ symbol: UIImage) {
        symbolImageView.image = symbol
        roundImageView.backgroundColor = .themeGreen
    }
    
    // 백그라운드 이미지 설정
    func setBackgroundImage(_ image: UIImage) {
        roundImageView.image = image
    }
    
    func setRoundImage(image: String?) {
        if let imageURL = image, let url = URL(string: apiUrl + imageURL) {
            self.roundImageView.kf.setImage(with: url)
            self.symbolImageView.isHidden = true
        } else {
            setSymbolImage(.workspace)
            symbolImageView.isHidden = false
        }
    }
}
