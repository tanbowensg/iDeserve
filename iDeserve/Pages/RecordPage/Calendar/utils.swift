//
//  utils.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/5.
//

import Foundation
import SwiftUI

let CalendarGridSize: CGFloat = 28
let CalendarGridVerticalSpacing: CGFloat = 6
let CalendarGridHorizontalSpacing: CGFloat = 15

let CalendarWidth: CGFloat = CalendarGridSize * 7 + CalendarGridHorizontalSpacing * 6

func getCalendarHeight(_ days: Int) -> CGFloat {
    CGFloat((Int(CalendarGridSize) * Int(days / 7 + 1)) + Int(CalendarGridVerticalSpacing) * Int(days / 7))
}

struct DayStat {
    var date: Date
    var income: Int
    var outcome: Int
}

// 根据 Records 统计每天一共赚了多少，用了多少
func reduceRecords (records: [Record], from: Date, to: Date) -> [DayStat] {
    let sortedRecords = records.sorted(by: {(r1: Record, r2: Record) in
        return r1.date! < r2.date!
    })

    var lastDate = from
    var dayStatCache: DayStat = DayStat(date: Date(timeIntervalSince1970: 0), income: 0, outcome: 0)
    var dayStats: [DayStat] = []
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "UTC")!
    
    for i in 0..<sortedRecords.count {
        let r = sortedRecords[i]

        if r.date! < lastDate || r.date! > to {
            continue
        }
        if !calendar.isDate(r.date!, inSameDayAs: lastDate) {
            dayStats.append(dayStatCache)
            dayStatCache = DayStat(date: r.date!, income: 0, outcome: 0)
        }

        switch Int(r.kind) {
            case RecordKind.task.rawValue:
                dayStatCache.income += Int(r.value)
            case RecordKind.goal.rawValue:
                dayStatCache.income += Int(r.value)
            case RecordKind.reward.rawValue:
                dayStatCache.outcome += Int(r.value)
            default: break
        }
        
        lastDate = r.date!
    }

//    去掉第一个1970年的
    if (dayStats.count > 0) {
        dayStats.remove(at: 0)
    }

//        加上最后一条
    if sortedRecords.count > 1 {
        dayStats.append(dayStatCache)
    }


    var results: [DayStat] = []

    //给一段时间头尾补上日期，正好能凑满一周
    let fromWeekDay = Calendar.current.dateComponents([Calendar.Component.weekday], from: from).weekday!
    let toWeekDay = Calendar.current.dateComponents([Calendar.Component.weekday], from: to).weekday!
    let start = Calendar.current.date(byAdding: .day, value: 1 - fromWeekDay, to: from)!
    var end = Calendar.current.date(byAdding: .day, value: 7 - toWeekDay, to: to)!
//    设置到一天最后一分钟
    end = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end)!

    var tempDate = start
    while tempDate <= end {
        var newDayStat = DayStat(date: tempDate, income: 0, outcome: 0)
        let oldDayStat = dayStats.first{ Calendar.current.isDate(tempDate, inSameDayAs: $0.date) }
        if let _ods = oldDayStat {
            newDayStat.income = _ods.income
            newDayStat.outcome = _ods.outcome
        }
        results.append(newDayStat)
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
    }

    return results
}

func getPrevMonth(year: Int, month: Int) -> (Int, Int) {
    let prevMonth = month == 1 ? 12 : month - 1
    let prevYear = month == 1 ? year - 1 : year
    return (prevYear, prevMonth)
}

func getNextMonth(year: Int, month: Int) -> (Int, Int) {
    let nextMonth = month == 12 ? 1 : month + 1
    let nextYear = month == 12 ? year + 1 : year
    return (nextYear, nextMonth)
}
