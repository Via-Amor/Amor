//
//  ProfileSectionModel.swift
//  Amor
//
//  Created by 김상규 on 11/8/24.
//

import Foundation
import RxDataSources

enum ProfileSectionModel {
    case profileImage(items: [ProfileSectionItem])
    case canChange(items: [ProfileSectionItem])
    case isStatic(items: [ProfileSectionItem])
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = ProfileSectionItem
    
    var items: [Item] {
        switch self {
        case .profileImage(items: let items):
            return items.map { $0 }
        case .canChange(let items):
            return items.map { $0 }
        case .isStatic(let items):
            return items.map { $0 }
        }
    }
    
    init(original: ProfileSectionModel, items: [Item]) {
        switch original {
        case .profileImage(let items):
            self = .profileImage(items: items)
        case .canChange(let items):
            self = .canChange(items: items)
        case .isStatic(let items):
            self = .isStatic(items: items)
        }
    }
}

enum ProfileSectionItem {
    case profileImageItem(ProfileElement)
    case canChangeItem(ProfileElement)
    case isStaticItem(ProfileElement)
}
