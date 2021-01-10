//
//  dateTools.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/10.
//

import Foundation

func dateToString (_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "zh_CN")
    return dateFormatter.string(from: date)
}

func endDateOfMonth(year: Int, month: Int) -> Date {
    let componentDay = DateComponents(day: 1)
    let calendar = Calendar.current
    let firstDayDate = calendar.nextDate(after: Date(), matching: componentDay, matchingPolicy: .previousTimePreservingSmallerComponents, direction: .backward)!

    let firsDayNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayDate)!
    let lastDayMonthDate = calendar.date(byAdding: .day, value: -1, to: firsDayNextMonth)!
    return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: lastDayMonthDate)!
}

func startDateOfMonth(year: Int, month: Int) -> Date {
    let componentDay = DateComponents(day: 1)
    let calendar = Calendar.current
    let startDay = calendar.nextDate(after: Date(), matching: componentDay, matchingPolicy: .previousTimePreservingSmallerComponents, direction: .backward)!
    return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDay)!
}
