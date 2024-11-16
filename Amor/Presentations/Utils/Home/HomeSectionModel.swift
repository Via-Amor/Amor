//
//  HomeSectionModel.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import Foundation
import RxDataSources

struct HomeSectionModel {
    var header: String
    var isOpen: Bool
    var items: [Item]
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeSectionItem
    
    init(original: HomeSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

enum HomeSectionItem {
    case myChannelItem(HomeCollectionViewCellModel)
    case dmRoomItem(HomeCollectionViewCellModel)
    case addMember(HomeCollectionViewCellModel)
}
