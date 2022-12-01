//
//  String+Extension.swift
//  SeSACFriends
//
//  Created by sae hun chung on 2022/12/01.
//

import Foundation

extension String {
    func stringToDate(format: String) -> Date? {
        let formatter = DateFormatter(format: format)
        return formatter.date(from: self)
    }
}

