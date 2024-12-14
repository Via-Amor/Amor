//
//  DMChatStorage.swift
//  Amor
//
//  Created by 김상규 on 12/6/24.
//

import Foundation
import RealmSwift
import RxSwift

protocol DMChatDatabase: AnyObject {
    func fetch(roomId: String) -> Single<Results<DMChat>>
    func insert(chatList: [DMChat])
    func insert(chat: DMChat)
    func deleteAll(dmId: String)
}

final class DMChatStorage: DMChatDatabase {
    private let realm: Realm!
    
    init() {
        realm = try! Realm()
    }
    
    func fetch(roomId: String) -> Single<Results<DMChat>> {
        return Single<Results<DMChat>>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            let result = realm.objects(DMChat.self).where { $0.roomId == roomId }
            observer(.success(result))
            return Disposables.create()
        }
    }
    
    func insert(chatList: [DMChat]) {
        try! realm.write {
            realm.add(chatList)
        }
    }
    
    func insert(chat: DMChat) {
        try! realm.write {
            realm.add(chat)
        }
    }
    
    func deleteAll(dmId: String) {
        let result = realm.objects(DMChat.self).where { $0.dmId == dmId }
        try! realm.write {
            realm.delete(result)
        }
    }
}
