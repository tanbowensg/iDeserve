//
//  dateToString.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/6.
//

import Foundation

func dateToString (_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "zh_CN")
    return dateFormatter.string(from: date)
}
