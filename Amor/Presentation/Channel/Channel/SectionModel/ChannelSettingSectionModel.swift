//
//  ChannelSettingSectionModel.swift
//  Amor
//
//  Created by 홍정민 on 11/30/24.
//

import Foundation
import RxDataSources

struct ChannelSettingSectionModel {
    var header: String
    var items: [Item]
}

extension ChannelSettingSectionModel: SectionModelType {
    typealias Item = ChannelMember
    
    init(original: ChannelSettingSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
