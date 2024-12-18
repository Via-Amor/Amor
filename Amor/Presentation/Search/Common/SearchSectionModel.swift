//
//  SearchSectionModel.swift
//  Amor
//
//  Created by 김상규 on 12/15/24.
//

import Foundation
import RxDataSources

struct SearchSectionModel {
    let section: Int
    var header: String
    var isOpen: Bool
    var items: [Item]
}

extension SearchSectionModel: SectionModelType {
    typealias Item = SearchSectionItem
    
    init(original: SearchSectionModel, items: [Item]) {
        self.section = original.section
        self.header = original.header
        self.isOpen = original.isOpen
        self.items = items
    }
}

enum SearchSectionItem {
    case channelItem(Channel)
    case memberItem(SpaceMember)
}
