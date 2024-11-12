//
//  UserDefaultsStorage.swift
//  Amor
//
//  Created by 홍정민 on 11/2/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let storage = UserDefaults.standard
    var key: String
    var defaultValue: T
    var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsStorage {
    private enum UserDefaultsKey: String {
        case access
        case refresh
        case userId
        case spaceId
    }
    
    @UserDefault(key: UserDefaultsKey.access.rawValue, defaultValue: "")
    static var token
    
    @UserDefault(key: UserDefaultsKey.refresh.rawValue, defaultValue: "")
    static var refresh
    
    @UserDefault(key: UserDefaultsKey.userId.rawValue, defaultValue: "")
    static var userId
    
    @UserDefault(key: UserDefaultsKey.spaceId.rawValue, defaultValue: "")
    static var spaceId

    static func removeAll() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
