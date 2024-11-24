//
//  HomeSectionModel.swift
//  Amor
//
//  Created by 김상규 on 11/16/24.
//

import Foundation
import RxDataSources

struct HomeSectionModel {
    let section: Int
    var header: String
    var isOpen: Bool
    var items: [Item]
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeSectionItem
    
    init(original: HomeSectionModel, items: [Item]) {
        self.section = original.section
        self.header = original.header
        self.isOpen = original.isOpen
        self.items = items
    }
}

enum HomeSectionItem {
    case myChannelItem(Channel)
    case dmRoomItem(DMRoom)
    case addMember(HomeCollectionViewCellModel)
}
