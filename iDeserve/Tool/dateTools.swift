//
//  dateTools.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/10.
//

import Foundation

func dateToString (_ date: Date, dateFormat: String? = nil) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = Locale(identifier: "zh_CN")
    return dateFormatter.string(from: date)
}

func endDateOfMonth(year: Int, month: Int) -> Date {
    let calendar = Calendar.current
    
    let nextYear = month == 12 ? year + 1 : year
    let nextMonth = month == 12 ? 1 : month + 1
    let components = DateComponents(year: nextYear, month: nextMonth, day: 1)
    
    let startDateOfNextMointh = calendar.date(from: components)!
    let endDate = calendar.date(byAdding: .day, value: -1, to: startDateOfNextMointh)!
    
    return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!
}

func startDateOfMonth(year: Int, month: Int) -> Date {
    let calendar = Calendar.current

    let components = DateComponents(year: year, month: month, day: 1)
    let startDate = calendar.date(from: components)!

    return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
}
