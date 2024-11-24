//
//  ChatFile.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import RealmSwift

class ChatFile: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var fileRoot: String
}
