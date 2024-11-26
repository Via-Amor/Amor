//
//  ImageLoadManager.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation
import Kingfisher

extension KingfisherManager {
    func setDefaultModifier()  {
        let modifier = AnyModifier { request in
            var req = request
            req.setValue(
                UserDefaultsStorage.token,
                forHTTPHeaderField: Header.authoriztion.rawValue
            )
            req.setValue(
                apiKey,
                forHTTPHeaderField: Header.sesacKey.rawValue
            )
            return request
        }
        
        KingfisherManager.shared.defaultOptions = [
            .requestModifier(modifier)
        ]
    }
}
