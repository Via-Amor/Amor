//
//  Date+.swift
//  Amor
//
//  Created by 홍정민 on 11/25/24.
//

import Foundation

extension Date {
    func toServerDateStr() -> String {
        return DateFormatManager.serverDate.string(from: self)
    }
}
