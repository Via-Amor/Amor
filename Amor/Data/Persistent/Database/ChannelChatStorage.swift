//
//  ChannelChatStorage.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RealmSwift
import RxSwift

protocol ChannelChatDatabase: AnyObject {
    func fetch(channelId: String) -> Single<Results<ChannelChat>>
    func insert(chatList: [ChannelChat])
    func insert(chat: ChannelChat)
    func deleteAll(channelId: String)
}

final class ChannelChatStorage: ChannelChatDatabase {
    private let realm: Realm!
    
    init() {
        realm = try! Realm()
        print("🐶Realm", realm.configuration.fileURL)
    }
    
    func fetch(channelId: String) -> Single<Results<ChannelChat>> {
        return Single<Results<ChannelChat>>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let result = realm.objects(ChannelChat.self).where { $0.channelId == channelId }
            observer(.success(result))
            return Disposables.create()
        }
    }
    
    func insert(chatList: [ChannelChat]) {
        try! realm.write {
            realm.add(chatList)
        }
    }
    
    func insert(chat: ChannelChat) {
        try! realm.write {
            realm.add(chat)
        }
    }
    
    func deleteAll(channelId: String) {
        let result = realm.objects(ChannelChat.self).where { $0.channelId == channelId }
        try! realm.write {
            realm.delete(result)
        }
        
    }
    
}
