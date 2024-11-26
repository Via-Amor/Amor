//
//  ChannelChatStorage.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RealmSwift

protocol ChannelDatabase: AnyObject {
    func fetch(channelId: String) -> Results<ChannelChat>
    func insert(chatList: [ChannelChat])
}

final class ChannelChatStorage: ChannelDatabase {
 
    private let realm: Realm!
    
    init() {
        realm = try! Realm()
        print("🐶Realm", realm.configuration.fileURL)
    }
    
    func fetch(channelId: String) -> Results<ChannelChat> {
        return realm.objects(ChannelChat.self).where { $0.channelId == channelId }
    }
    
    func insert(chatList: [ChannelChat]) {
        try! realm.write {
            realm.add(chatList)
        }
    }
}
