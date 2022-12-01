//
//  Date+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

extension Date {
    func dateToString(format: String) -> String {
        let formatter = DateFormatter(format: format)
        return formatter.string(from: self)
    }
}
