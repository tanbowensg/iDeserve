//
//  RepeatFrequency.swift
//  iDeserve
//
//  Created by 谈博文 on 2020/10/10.
//

import Foundation

enum RepeatFrequency: Int, CaseIterable {
    case never = 0
    case daily = 1
    case weekly = 2
    case monthly = 3
    case unlimited = 4
    case twoDays = 5
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
    case RepeatFrequency.unlimited:
        return "无间隔重复"
    case RepeatFrequency.twoDays:
        return "每隔一天"
    }
}
