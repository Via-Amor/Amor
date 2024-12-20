//
//  UIButton+.swift
//  Amor
//
//  Created by 홍정민 on 12/20/24.
//

import UIKit
import Kingfisher

extension UIButton {
    func setImageFromURL(url: String) {
        guard let imageURL = URL(string: apiUrl + url) else { return }
        let retry = DelayRetryStrategy(maxRetryCount: 2, retryInterval: .seconds(3))
        
        kf.setImage(
            with: imageURL,
            for: .normal,
            options: [.retryStrategy(retry)], completionHandler: { result in
                switch result {
                case .success:
                    return
                case .failure(let error):
                    TokenManager.shared.refreshToken { result in
                        switch result {
                        case .success(let value):
                            UserDefaultsStorage.token = value.accessToken
                            KingfisherManager.shared.setDefaultModifier()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            })
        
    }
}
