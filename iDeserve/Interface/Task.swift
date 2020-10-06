//
//  Task.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/9/30.
//

import Foundation

struct Task: Hashable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var done: Bool = false
    //    分值
    var value: Int
    //    重复频率
    var repeatFrequency: RepeatFrequency = RepeatFrequency.never
    //    重要任务
    var starred: Bool = false
    //    截止时间
    var ddl: String?
    //    描述
    var desc: String = ""
    //    父任务 id
    var parent: String?
}

enum RepeatFrequency: Int, CaseIterable {
    case never = 0
    case daily = 1
    case weekly = 2
    case monthly = 3
}

func getRepeatFrequencyText (_ value: RepeatFrequency) -> String {
    switch value {
    case RepeatFrequency.never:
        return "从不"
    case RepeatFrequency.daily:
        return "每天"
    case RepeatFrequency.weekly:
        return "每周"
    case RepeatFrequency.monthly:
        return "每月"
    }
}
