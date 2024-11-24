//
//  ChannelChatRepository.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RealmSwift

protocol ChannelDatabase: AnyObject {
    func fetch() -> Results<ChannelChat>
}

final class ChannelChatDatabase: ChannelDatabase {
    private let realm: Realm!
    
    init() {
        realm = try! Realm()
    }
    
    func fetch() -> Results<ChannelChat> {
        return realm.objects(ChannelChat.self)
    }
}
