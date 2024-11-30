//
//  String+.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import Foundation

extension String {
    func validateRegex(regex: UserRegex) -> Bool {
        if let _ = self.range(of: regex.rawValue, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
    
    func findRange(str: String) -> NSRange? {
        if let range = self.range(of: str) {
            return NSRange(range, in: self)
        } else {
            return nil
        }
    }
    
    func toServerDate() -> Date {
        let serverDate = DateFormatManager.serverDate.date(from: self) ?? Date()
        return serverDate
    }
    
    func isToday() -> Bool {
        let date = self.toServerDate()
        return Calendar.current.isDateInToday(date)
    }

    func toChatTime() -> String {
        let serverDate = self.toServerDate()
        let chatTime = DateFormatManager.chatTime.string(from: serverDate)
        return chatTime
    }
    
    func toChatDate() -> String {
        let serverDate = self.toServerDate()
        let chatDateTime = DateFormatManager.chatDate.string(from: serverDate)
        return chatDateTime
    }
    
    func toSpaceCreatedDate() -> String {
        let serverDate = self.toServerDate()
        let spaceCreatedDate = DateFormatManager.spaceCreatedDate.string(from: serverDate)
        return spaceCreatedDate
    }
}
