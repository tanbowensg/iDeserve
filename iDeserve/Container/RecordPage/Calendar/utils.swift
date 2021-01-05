//
//  utils.swift
//  iDeserve
//
//  Created by 谈博文 on 2021/1/5.
//

import Foundation

struct DayStat {
    var date: Date
    var income: Int
    var outcome: Int
}

// 根据Records统计每天一共赚了多少，用了多少
func reduceRecords (records: [Record], from: Date, to: Date) -> [DayStat] {
    let sortedRecords = records.sorted(by: {(r1: Record, r2: Record) in
        return r1.date! < r2.date!
    })

    var lastDate = from
    var dayStatCache: DayStat = DayStat(date: Date(timeIntervalSince1970: 0), income: 0, outcome: 0)
    var results: [DayStat] = []
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(identifier: "UTC")!

    for i in 0..<sortedRecords.count {
        let r = sortedRecords[i]

        if r.date! < lastDate || r.date! > to {
            continue
        }
        if !calendar.isDate(r.date!, inSameDayAs: lastDate) {
            results.append(dayStatCache)
            dayStatCache = DayStat(date: r.date!, income: 0, outcome: 0)
        }

        switch Int(r.kind) {
            case RecordKind.task.rawValue:
                dayStatCache.income += Int(r.value)
            case RecordKind.reward.rawValue:
                dayStatCache.income -= Int(r.value)
            default: break
        }
        
//        加上最后一条
        if i == sortedRecords.count - 1 && sortedRecords.count > 1 {
            results.append(dayStatCache)
        }
        
        lastDate = r.date!
    }
//    去掉第一个1970年的
    results.remove(at: 0)
    print("reduce过的")
    print(results)

    return results
}

//给一段时间头尾补上日期，正好能凑满一周
func fillDayStats(dayStats: [DayStat]) -> [DayStat] {
    var results: [DayStat] = []
    if dayStats.count == 0 {
        return results
    }

    let from = dayStats[0].date
    let to = dayStats[dayStats.count - 1].date
    let fromWeekDay = Calendar.current.dateComponents([Calendar.Component.weekday], from: from).weekday!
    let toWeekDay = Calendar.current.dateComponents([Calendar.Component.weekday], from: to).weekday!
    let start = Calendar.current.date(byAdding: .day, value: 1 - fromWeekDay, to: from)!
    let end = Calendar.current.date(byAdding: .day, value: 7 - toWeekDay, to: to)!

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
    
    print("fill过的")
    print(results)
    return results
}
